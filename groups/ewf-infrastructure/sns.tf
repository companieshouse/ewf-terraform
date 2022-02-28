module "cloudwatch_sns_notifications" {
  count = var.enable_sns_topic ? 1 : 0

  source  = "terraform-aws-modules/sns/aws"
  version = "3.3.0"

  name_prefix       = "${var.application}-cloudwatch-"
  display_name      = "${var.application}-cloudwatch-alarms"
  kms_master_key_id = local.sns_kms_key_id

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}