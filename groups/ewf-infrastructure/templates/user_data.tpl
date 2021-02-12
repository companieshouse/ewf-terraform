#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#Generate new cloudwatch conf file with updated log group and load into cw agent service
python /root/cw_log_conf.py \
 -g ${LOG_GROUP_NAME} \
 -o "amazon-cloudwatch-agent.log" \
 -l "/var/log/httpd/ewf_access_log" "/var/log/httpd/ewf_error_log"
. /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:amazon-cloudwatch-agent.log -s
#env output
env
#Create key:value variable
cat <<EOF >>inputs.yaml
${EWF_FRONTED}
EOF
#Create the TNSNames.ora file for Oracle
/usr/local/bin/j2 -f yaml /usr/lib/oracle/11.2/client64/lib/tnsnames.j2 inputs.yaml > /usr/lib/oracle/11.2/client64/lib/tnsnames.ora
#Create and populate httpd config and change owner
/usr/local/bin/j2 -f yaml /etc/httpd/conf/httpd.conf.j2 inputs.yaml > /etc/httpd/conf/httpd.conf
chown apache:apache /etc/httpd/conf/httpd.conf
#Create and populate the perl config and change owner
/usr/local/bin/j2 -f yaml /etc/httpd/conf.d/ewf_perl.conf.j2 inputs.yaml > /etc/httpd/conf.d/ewf_perl.conf
chown apache:apache /etc/httpd/conf.d/ewf_perl.conf
#Remove unnecessary files
rm /etc/httpd/conf.d/welcome.conf
rm /etc/httpd/conf.d/ssl.conf
rm /etc/httpd/conf.d/perl.conf
#Run Ansible deployment to download and install the app
/usr/local/bin/ansible-playbook /root/deployment.yml -e "s3_bucket=${S3_RELEASE_BUCKET} version=${APP_VERSION}"
#Enable and start httpd
chkconfig httpd on
service httpd start

