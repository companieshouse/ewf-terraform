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
    }
  ]
}