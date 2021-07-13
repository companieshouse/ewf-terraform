#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#Create key:value variable
cat <<EOF >>inputs.json
${EWF_FRONTEND_INPUTS}
EOF
#Update Nagios registration script with relevant template
cp /usr/local/bin/nagios-host-add.sh /usr/local/bin/nagios-host-add.j2
REPLACE=EWF_Web_${HERITAGE_ENVIRONMENT} /usr/local/bin/j2 /usr/local/bin/nagios-host-add.j2 > /usr/local/bin/nagios-host-add.sh
#Create the TNSNames.ora file for Oracle
/usr/local/bin/j2 -f json /usr/lib/oracle/11.2/client64/lib/tnsnames.j2 inputs.json > /usr/lib/oracle/11.2/client64/lib/tnsnames.ora
#Remove unnecessary files
rm /etc/httpd/conf.d/welcome.conf
rm /etc/httpd/conf.d/ssl.conf
rm /etc/httpd/conf.d/perl.conf
#Create and populate httpd config
/usr/local/bin/j2 -f json /etc/httpd/conf/httpd.conf.j2 inputs.json > /etc/httpd/conf/httpd.conf
#Create and populate the perl config
/usr/local/bin/j2 -f json /etc/httpd/conf.d/ewf_perl.conf.j2 inputs.json > /etc/httpd/conf.d/ewf_perl.conf
#Run Ansible playbook for Frontend deployment using provided inputs
/usr/local/bin/ansible-playbook /root/frontend_deployment.yml -e '${ANSIBLE_INPUTS}'
