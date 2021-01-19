# module "ewf-fe-logging" {
#     source = "git@github.com:companieshouse/terraform-modules//aws/instance-profile?ref=tags/1.0.30"

#     name      = "ewf-fe-cw-logs"
#     statement = [
#         { 
#             sid = "ewfloggroupwrite"
#             effect = "Allow"
#             resources = [
#                 aws_cloudwatch_log_group.ewf_fe.arn
#             ]
#             actions = [
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents",
#             ]
#         }
#     ] 
# }