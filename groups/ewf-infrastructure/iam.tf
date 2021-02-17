module "ewf_frontend_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.40"

  name              = "ewf_frontend_profile"
  enable_SSM        = true
  cw_log_group_arns = [aws_cloudwatch_log_group.ewf_fe.arn]
  instance_asg_arns = [module.frontend_asg.this_autoscaling_group_arn]
  kms_key_refs      = ["alias/${var.account}/${var.region}/ebs"]
  custom_statements = [
    {
      sid    = "AllowAccessToReleaseBucket",
      effect = "Allow",
      resources = [
        "arn:aws:s3:::shared-services.eu-west-2.releases.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.releases.ch.gov.uk"
      ],
      actions = [
        "s3:Get*",
        "s3:List*",
      ]
    }
  ]
}