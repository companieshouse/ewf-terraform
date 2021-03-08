############################LIVE SERVICE PROCESSING START############################
#Form Processing Jobs
# Monday
*/1 * * * 1 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
*/10 * * * 1 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
# ...or on demand
#*/1 0-18 * * 1 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 22-23 * * 1 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-18 * * 1 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 22-23 * * 1 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1

# Tuesday
*/1 * * * 2 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
*/10 * * * 2 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
# ...or on demand
#*/1 0-18 * * 2 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 22-23 * * 2 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-18 * * 2 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 22-23 * * 2 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1

# Wednesday
*/1 * * * 3 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
*/10 * * * 3 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#...or on demand
#*/1 0-18 * * 3 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 22-23 * * 3 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-18 * * 3 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 22-23 * * 3 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1

# Thursday
*/1 * * * 4 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 * * * 4 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
# ...or on demand
#*/1 0-18 * * 4 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 22-23 * * 4 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-18 * * 4 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 22-23 * * 4 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1

# Friday
*/1 * * * 5 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
*/10 * * * 5 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#...or on demand
#*/1 0-18 * * 5 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 22-23 * * 5 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-18 * * 5 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 22-23 * * 5 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1

# Saturday
*/1 * * * 6 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
*/10 * * * 6 /home/ewf/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#...or on demand
#*/1 0-7 * * 6 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 22-23 * * 6 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-7 * * 6 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 22-23 * * 6 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1

# Sunday
*/1 * * * 0 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
*/10 * * * 0 /home/ewf/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#...or on demand
#*/1 0-18 * * 0 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/1 20-23 * * 0 /home/ewf/efbackend/formPartition.sh >/dev/null 2>&1
#*/10 0-18 * * 0 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
#*/10 20-23 * * 0 /home/ewf/supportbackend/efbackend/formProcessFormsEnablementLive.sh >/dev/null 2>&1
############################LIVE SERVICE PROCESSING END############################

#######################Form Process Start##############################
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh General >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Shuttles >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Accounts >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Incorporations >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh SameDayIncorporations >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formProcess.sh Mortgages >/dev/null 2>&1

#######################Form Process End##############################

###################OTHER SCHEDULED JOBS#########################
*/1 0-23 * * * /home/ewf/efbackend/CreateCerts.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/formResponse.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/emailDispatcher.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/cancelledSubmissions.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/filedDataPDF.sh now >/dev/null 2>&1
*/10 0-23 * * * /home/ewf/supportbackend/efbackend/monitorLCKfilesWarn.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/efbackend/auth.sh >/dev/null 2>&1
*/1 7-21 * * * /home/ewf/efbackend/presenter.sh >/dev/null 2>&1
*/1 * * * * /home/ewf/chd3backend/paymentTXCommunicate.sh >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/bcdbackend/communicationDispatcher.sh >/dev/null 2>&1
##MAW 20/04/15, partitioning running slow, so tried this
*/10 * * * * /home/ewf/efbackend/formArchive.sh 365 >/dev/null 2>&1

#Chd3backend to handle emailed shuttle PDFs etc
*/1 0-23 * * * /home/ewf/chd3backend/partition.sh >/dev/null 2>&1
*/4 0-23 * * * /home/ewf/chd3backend/reports.sh now >/dev/null 2>&1
*/1 0-23 * * * /home/ewf/chd3backend/email.sh >/dev/null 2>&1

###################NFS Cleanup Start#########################
15 0 * * * find /mnt/nfs/ewf/upload -type f -mtime +365 -name ".html" -exec rm -f {} ; >/dev/null 2>&1
15 1 * * * find /mnt/nfs/ewf/upload -type f -mtime +90 ( -name *.xml -o -name *.pcl -o -name *.pdf ) -exec rm -f {} ; >/dev/null 2>&1
15 2 * * * find /mnt/nfs/ewf/upload -type f -name ".xdp" -mtime +3  -exec rm -f {} ; >/dev/null 2>&1
15 14 * * * find /mnt/nfs/ewf/upload -type f -name "*.xdp" -mtime +3  -exec rm -f {} ; >/dev/null 2>&1
15 3 * * * find /mnt/ha/image/ewf2 -type f -mtime +9 -exec rm -f {} ; >/dev/null 2>&1
20 14 * * * find /mnt/ha/image/ewf2 -type f -mtime +9 -exec rm -f {} ; >/dev/null 2>&1
15 4 * * * find /mnt/nfs/ewf/data/image -type f -mtime +30 -exec rm -f {} ; >/dev/null 2>&1
25 14 * * * find /mnt/nfs/ewf/data/image -type f -mtime +30 -exec rm -f {} ; >/dev/null 2>&1
###################NFS Cleanup End#########################

###################EReminders Start#########################
*/1,2,3 * * * * /home/ewf/efbackend/eReminderMatch.sh >/dev/null 2>&1
*/5 * * * * /home/ewf/efbackend/eReminderWarn.sh >/dev/null 2>&1
5 6 * * * /home/ewf/efbackend/eRemindersImport.sh >/dev/null 2>&1
*/10 1-6 * * * /home/ewf/efbackend/eRemindersCleanup.sh >/dev/null 2>&1
###################EReminders End#########################

###################MISC Start#########################
#*/20 * * * * /home/ewf/bcdbackend/communicationWeeding.sh >/dev/null 2>&1
0 4 * * * /home/ewf/efbackend/corporationTax.sh >/dev/null 2>&1
*/15 * * * * /home/ewf/efbackend/failedPayments.sh >/dev/null 2>&1
# email Warn double hashed out for repayments go-live 4/2/2012
0 5 * * * /home/ewf/efbackend/emailWarn.sh >/dev/null 2>&1
*/20  * * * * /home/ewf/efbackend/weed.sh ewf >/dev/null 2>&1
#extra session weeding for a few hours, just incase tux2 is not weeding
*/10  0-7 * * * /home/ewf/efbackend/weed.sh ewf sessions >/dev/null 2>&1
#JSON stats for Helen H. had to put these back onto bep1 as they will not run from cron and not got time to look at these with Brexit move to london
#1 0 * * * /home/ewf/statsjson/dailyjsonstats.pl >> /home/ewf/statsjson/jsonstats.log
#2 * * * * /home/ewf/statsjson/newjsonstats.pl >> /home/ewf/statsjson/newjsonstats.log
###################MISC End#########################

################################STATS GENERATION START#############################
0 6 * * 1 /home/ewf/supportbackend/efbackend/getOptIns.sh >/dev/null 2>&1
0 6 1 * * /home/ewf/efbackend/produceStats.sh AccountFilingReport "cyoude@companieshouse.gov.uk" month >/dev/null 2>&1
0 4 1 * * /home/ewf/efbackend/produceStats.sh IncFormationReport "thill@companieshouse.gov.uk" month >/dev/null 2>&1
0 6 7 * * /home/ewf/efbackend/produceStats.sh HMRCIncStatReport "internalstats@companieshouse.gov.uk" lastmonth >/dev/null 2>&1
15 4 1 * * /home/ewf/efbackend/produceStats.sh AverageProcessTimeReport "ACINotify@companieshouse.gov.uk,internalstats@companieshouse.gov.uk" month >/dev/null 2>&1
30 6 1 * * /home/ewf/efbackend/produceStats.sh AverageMonthlyTotalReport "ACINotify@companieshouse.gov.uk,internalstats@companieshouse.gov.uk" month >/dev/null 2>&1
10 0 1 * * /home/ewf/efbackend/produceStats.sh WebFiledRejectsReport "internalstats@companieshouse.gov.uk" month >/dev/null 2>&1
10 1 1 * * /home/ewf/efbackend/produceStats.sh AcceptedRejectedIncsReport "internalstats@companieshouse.gov.uk" month >/dev/null 2>&1
40 1 * * * /home/ewf/efbackend/produceStats.sh AcceptedRejectedSameDayIncsReport "internalstats@companieshouse.gov.uk,internalstats@companieshouse.gov.uk" yesterday >/dev/null 2>&1
00 20 * * * /home/ewf/efbackend/produceFTPStats.sh WebAccountPaymentsReport 172.16.200.33 ${ USER } ${ PASSWORD } 8to8 >/dev/null 2>&1
40 2 * * * /home/ewf/efbackend/produceStats.sh CardPaymentsReport "internalstats@companieshouse.gov.uk" yesterday >/dev/null 2>&1
10 3 * * 1 /home/ewf/efbackend/produceStats.sh WeeklyAcceptedDocsReport "internalstats@companieshouse.gov.uk" week >/dev/null 2>&1
40 3 * * * /home/ewf/efbackend/produceStats.sh DailyAcceptedRejectedDocsReport "internalstats@companieshouse.gov.uk" yesterday >/dev/null 2>&1
10 4 * * * /home/ewf/efbackend/produceStats.sh ExtendedAcceptedRejectedDocsReport "internalstats@companieshouse.gov.uk" yesterday >/dev/null 2>&1
40 4 * * * /home/ewf/efbackend/produceStats.sh WebFiledDailyDocsReport "internalstats@companieshouse.gov.uk" yesterday >/dev/null 2>&1
40 5 * * * /home/ewf/efbackend/produceFTPStats.sh CardPaymentsReport 172.16.200.33 ${ USER } ${ PASSWORD } yesterday >/dev/null 2>&1
15 5 * * * /home/ewf/efbackend/produceStats.sh TwelveHourProcessingReportEW "internalstats@companieshouse.gov.uk" dayBefore_Ysterday_5to5_working_days_EW >/dev/null 2>&1
35 5 * * * /home/ewf/efbackend/produceStats.sh TwelveHourProcessingReportSC "internalstats@companieshouse.gov.uk" dayBefore_Ysterday_5to5_working_days_SC >/dev/null 2>&1
55 5 * * * /home/ewf/efbackend/produceStats.sh TwelveHourProcessingReportNI "internalstats@companieshouse.gov.uk" dayBefore_Ysterday_5to5_working_days_NI >/dev/null 2>&1
15 7 * * * /home/ewf/efbackend/produceStats.sh TwentyFourHourProcessingReportEW "internalstats@companieshouse.gov.uk" dayBefore_Ysterday_5to5_working_days_EW >/dev/null 2>&1
35 7 * * * /home/ewf/efbackend/produceStats.sh TwentyFourHourProcessingReportSC "internalstats@companieshouse.gov.uk,internalstats@companieshouse.gov.uk" dayBefore_Ysterday_5to5_working_days_SC >/dev/null 2>&1
55 7 * * * /home/ewf/efbackend/produceStats.sh TwentyFourHourProcessingReportNI "internalstats@companieshouse.gov.uk" dayBefore_Ysterday_5to5_working_days_NI >/dev/null 2>&1
20 6 * * * /home/ewf/efbackend/produceFTPStats.sh RejectsToRefundReport 172.16.200.33 ${ USER } ${ PASSWORD } yesterday >/dev/null 2>&1
20 5 * * * /home/ewf/efbackend/produceStats.sh RejectsToRefundReport "internalstats@companieshouse.gov.uk,internalstats@companieshouse.gov.uk" yesterday >/dev/null 2>&1
40 23 * * * /home/ewf/chd3backend/paymentTXReport.sh >/dev/null 2>&1
29 8-18 * * 1-5 /home/ewf/efbackend/produceStats.sh SupportHourlyStatsReport "mwilliams5@companieshouse.gov.uk,dcornelius@companieshouse.gov.uk,sreadman@companieshouse.gov.uk,pparr@companieshouse.gov.uk,cnewland@companieshouse.gov.uk" >/dev/null 2>&1
0 11,16,20 * * * /home/ewf/efbackend/produceStats.sh SupportHourlyStatsReport "678104@gmail.com" >/dev/null 2>&1
################################STATS GENERATION END#############################

###################################SUPPORT SECTION START##############################
*/10 * * * * /home/ewf/supportbackend/efbackend/jadeMonitor.sh >/dev/null 2>&1
0 8-17 * * 1-5 /home/ewf/updateEWFFormDetail.sh >/dev/null 2>&1
0 8 * * * /home/ewf/deleteoldaccounts.sh >/dev/null 2>&1
0 9 * * * /home/ewf/stuckAuthCodes.sh >/dev/null 2>&1
59 23 * * * /home/ewf/ServerBusyStat.sh >/dev/null 2>&1
*/1 * * * * /home/ewf/errorlogcheck.sh -700 >/dev/null 2>&1
#1 6 * * 1 /home/ewf/getEreminderSignups.sh >/dev/null 2>&1
1 5 1 * * /home/ewf/BCD_EremSignUp.sh >/dev/null 2>&1
*/15 7-18 * * * /home/ewf/efbackend/status7TNEP.sh >/dev/null 2>&1
*/30 7-18 * * * /home/ewf/BCD_EmailWaiting.sh >/dev/null 2>&1
4,34 * * * * /home/ewf/efbackend/filinqueuecheck.sh email >/dev/null 2>&1 
*/15 7-18 * * * /home/ewf/efbackend/updateGenBarcodeSub.sh >/dev/null 2>&1
#Barclaycard Payment fail check
5,35 * * * * /home/ewf/efbackend/paymentfailcheck.sh email >/dev/null 2>&1
#tidy up the pdf copies of filings, only need 10 days
30 19 * * * /home/ewf/supportbackend/efbackend/pdfcleanup.sh >/dev/null 2>&1
*/5 * * * * /home/ewf/authlogcheck.sh -700 >/dev/null 2>&1
*/1 * * * * /home/ewf/eReminderlogcheck.sh -700 >/dev/null 2>&1
0 4 * * * /home/ewf/supportbackend/efbackend/checkregofficefails.sh >/dev/null 2>&1
0 7,12,16,18 * * 1-5 /home/ewf/updatedb.sh >/dev/null 2>&1
0 10 * * 0,6 /home/ewf/updatedb.sh >/dev/null 2>&1
45 0-23 * * * /home/ewf/checkForRecentFilings.sh >/dev/null 2>&1
5 7-17 * * * /home/ewf/efGenFail.sh >/dev/null 2>&1
15 7-18 * * * /home/ewf/PresInsertFail.sh >/dev/null 2>&1
####### Check for failed auth code request fails
30 7 * * * /home/ewf/getewfauthfail.sh email >/dev/null 2>&1
5 8-17 * * * /home/ewf/checkEmailFail.sh >/dev/null 2>&1

###################################SUPPORT SECTION END##############################
