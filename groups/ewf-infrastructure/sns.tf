module "cloudwatch_sns_notifications" {
  count = var.enable_sns_topic ? 1 : 0

  source  = "terraform-aws-modules/sns/aws"
  version = "3.3.0"

  name              = "${var.application}-emails"
  display_name      = "${var.application}-cloudwatch-alarms-for-emails"
  kms_master_key_id = local.sns_kms_key_id

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}

module "cloudwatch_sns_xmatters" {
  count = var.enable_sns_topic ? 1 : 0

  source  = "terraform-aws-modules/sns/aws"
  version = "3.3.0"

  name              = "${var.application}-xmatters-only"
  display_name      = "${var.application}-cloudwatch-alarms-for-xmatters"
  kms_master_key_id = local.sns_kms_key_id

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}