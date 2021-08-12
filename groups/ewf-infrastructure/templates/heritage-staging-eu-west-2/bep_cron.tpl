####################################STAGING / PREPRODUCTION CRON ####################################

*/1 0-23 * * * /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1

########################Form Process Start##############################
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh General >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Shuttles >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Accounts >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Incorporations >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh SameDayIncorporations >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Mortgages >/dev/null 2>&1

########################Form Process End##############################

####################OTHER SCHEDULED JOBS#########################
*/1 0-23 * * * /home/ewf/efbackend/CreateCerts.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formResponse.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/emailDispatcher.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/cancelledSubmissions.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/filedDataPDF.sh now >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/auth.sh >/dev/null 2>&1
*/1 7-21 * * * /home/ewf/efbackend/presenter.sh >/dev/null 2>&1
*/1 * * * * /home/ewf/chd3backend/paymentTXCommunicate.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/bcdbackend/communicationDispatcher.sh >/dev/null 2>&1

##Chd3backend to handle emailed shuttle PDFs etc
*/1 0-23 * * * /home/ewf/chd3backend/partition.sh >/dev/null 2>&1
*/4 0-23 * * * /home/ewf/chd3backend/reports.sh now >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/chd3backend/email.sh >/dev/null 2>&1

