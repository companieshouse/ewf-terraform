module "ewf_fe_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.40"

  name       = "ewf-frontend-profile"
  enable_SSM = true
  cw_log_group_arns = [
    "${aws_cloudwatch_log_group.ewf_fe.arn}:*",
    "${aws_cloudwatch_log_group.ewf_fe.arn}:*:*",
  ]
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
  cw_log_group_arns = [
    "${aws_cloudwatch_log_group.ewf_bep.arn}:*",
    "${aws_cloudwatch_log_group.ewf_bep.arn}:*:*",
  ]
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