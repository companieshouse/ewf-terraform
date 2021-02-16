module "ewf_frontend_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.31"

  name = "ewf_frontend_profile"
  statement = [
    {
      sid    = "ewfloggroupwrite"
      effect = "Allow"
      resources = [
        aws_cloudwatch_log_group.ewf_fe.arn
      ]
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
    },
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
    },
    {
      sid    = "AllowInstanceHealthActions",
      effect = "Allow",
      resources = [
        module.asg.this_autoscaling_group_arn
      ],
      actions = [
        "autoscaling:SetInstanceHealth"
      ]
    }
  ]
}