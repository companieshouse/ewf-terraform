#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

GET_PARAM_COMMAND="/usr/local/bin/aws ssm get-parameter --with-decryption --region ${REGION} --output text --query Parameter.Value --name"

#Create key:value variable
$${GET_PARAM_COMMAND} '${EWF_BACKEND_INPUTS_PATH}' > inputs.json
#Create cron file and set crontab for EWF user:
$${GET_PARAM_COMMAND} '${EWF_CRON_ENTRIES_PATH}' | base64 -d | gunzip > /root/cronfile
crontab -u ewf /root/cronfile
#Add finance mount and group to staging and live here as we can't use RHEL6 base ami anymore to get the ansible to work
EWF_ENV=$($${GET_PARAM_COMMAND} '${HERITAGE_ENVIRONMENT}')
if [ $EWF_ENV == 'Staging'] || [$EWF_ENV == 'Live']
then
FINANCE_GID=$($${GET_PARAM_COMMAND} '${FINANCE_BE_GID}')
FINANCE_GROUP=$($${GET_PARAM_COMMAND} '${FINANCE_BE_GROUP}')
EWF_USER=$($${GET_PARAM_COMMAND} '${EWF_BE_USER}')
groupadd -g $FINANCE_GID $FINANCE_GROUP
usermod -a -G $FINANCE_GID $EWF_USER
mkdir /mnt/nfs/e5_upload
$${GET_PARAM_COMMAND} '${EWF_FINANCE_MOUNT_PATH}' | base64 -d | gunzip >> /etc/fstab
fi
#Set FESS_TOKEN
FESS_TOKEN=$($${GET_PARAM_COMMAND} '${EWF_FESS_TOKEN_PATH}')
echo "export FESS_TOKEN=$${FESS_TOKEN}" >> /home/ewf/.bash_profile
#Create the TNSNames.ora file for Oracle
/usr/local/bin/j2 -f json /usr/lib/oracle/11.2/client64/lib/tnsnames.j2 inputs.json > /usr/lib/oracle/11.2/client64/lib/tnsnames.ora
#Remove unnecessary files
rm /etc/httpd/conf.d/welcome.conf
rm /etc/httpd/conf.d/ssl.conf
rm /etc/httpd/conf.d/perl.conf
#Run Ansible playbook for Backend deployment using provided inputs
$${GET_PARAM_COMMAND} '${ANSIBLE_INPUTS_PATH}' | base64 -d | gunzip > /root/ansible_inputs.json
echo "Deploying ${APP_VERSION}"
/usr/local/bin/ansible-playbook /root/backend_deployment.yml -e '@/root/ansible_inputs.json'
# Update hostname and reboot
INSTANCEID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
sed -i "s/HOSTNAME=.*/HOSTNAME=$INSTANCEID/" /etc/sysconfig/network
sed -i "s/\b127.0.0.1\b/127.0.0.1 $INSTANCEID/" /etc/hosts
# Reboot to take effect
reboot
