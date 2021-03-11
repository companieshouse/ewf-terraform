module "ewf_fe_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.40"

  name       = "ewf-frontend-profile"
  enable_SSM = true
  cw_log_group_arns = length(local.fe_log_groups) > 0 ? [
    formatlist(
      "arn:aws:logs:%s:%s:log-group:%s-fe-%s:*:*",
      var.aws_region,
      data.aws_caller_identity.current.account_id,
      var.application,
      local.fe_log_groups
      ),
    format("arn:aws:logs:%s:%s:log-group:%s-fe-%s:*",
      var.aws_region,
      data.aws_caller_identity.current.account_id,
      var.application,
      local.fe_log_groups
    ),
  ] : null
  instance_asg_arns = [module.fe_asg.this_autoscaling_group_arn]
  kms_key_refs      = ["alias/${var.account}/${var.region}/ebs"]
  custom_statements = [
    {
      sid    = "AllowAccessToReleaseBucket",
      effect = "Allow",
      resources = [
        "arn:aws:s3:::shared-services.eu-west-2.releases.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.releases.ch.gov.uk",
        "arn:aws:s3:::shared-services.eu-west-2.configs.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.configs.ch.gov.uk"
      ],
      actions = [
        "s3:Get*",
        "s3:List*",
      ]
    }
  ]
}

module "ewf_bep_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.40"

  name       = "ewf-backend-profile"
  enable_SSM = true
  cw_log_group_arns = length(local.bep_log_groups) > 0 ? [
    formatlist(
      "arn:aws:logs:%s:%s:log-group:%s-bep-%s:*:*", 
      var.aws_region, 
      data.aws_caller_identity.current.account_id, 
      var.application,
      local.bep_log_groups
    ),
    format("arn:aws:logs:%s:%s:log-group:%s-bep-%s:*",
      var.aws_region, 
      data.aws_caller_identity.current.account_id, 
      var.application,
      local.bep_log_groups
    ),
  ] : null
  instance_asg_arns = [module.bep_asg.this_autoscaling_group_arn]
  kms_key_refs      = ["alias/${var.account}/${var.region}/ebs"]
  custom_statements = [
    {
      sid    = "AllowAccessToReleaseBucket",
      effect = "Allow",
      resources = [
        "arn:aws:s3:::shared-services.eu-west-2.releases.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.releases.ch.gov.uk",
        "arn:aws:s3:::shared-services.eu-west-2.configs.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.configs.ch.gov.uk"
      ],
      actions = [
        "s3:Get*",
        "s3:List*",
      ]
    }
  ]
}