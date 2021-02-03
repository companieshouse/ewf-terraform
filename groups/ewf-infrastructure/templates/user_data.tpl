#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
#Generate new cloudwatch conf file with updated log group and load into cw agent service
python cw_log_conf.py \
-g ${LOG_GROUP_NAME} \
-o "amazon-cloudwatch-agent.log" \
-l "/var/log/httpd/ewf_access_log" "/var/log/httpd/ewf_error_log"
. /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:amazon-cloudwatch-agent.log -s
#Replace servername directive with correct value in httpd.conf
sed -i -e "s/REGEXREPLACE_SERVERNAME/${SERVER_NAME}/g" /etc/httpd/conf/httpd.conf
#Create the TNSNames.ora file for Oracle
cat <<EOF >>/usr/lib/oracle/11.2/client64/lib/tnsnames.ora
${TNS_NAMES}
EOF