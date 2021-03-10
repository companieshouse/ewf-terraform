# ------------------------------------------------------------------------------
# EWF Frontend Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_fe_asg_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-fe-asg-001"
  description = "Security group for the ${var.application} frontend asg"
  vpc_id      = data.aws_vpc.vpc.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.ewf_internal_alb_security_group.this_security_group_id
    },
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.ewf_external_alb_security_group.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  egress_rules = ["all-all"]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}

resource "aws_cloudwatch_log_group" "ewf_fe" {
  for_each = local.fe_cw_logs

  name              = each.value["log_group_name"]
  retention_in_days = lookup(each.value, "log_group_retention", var.fe_default_log_group_retention_in_days)

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )
}

# ASG Module
module "fe_asg" {
  source = "git@github.com:companieshouse/terraform-modules//aws/terraform-aws-autoscaling?ref=tags/1.0.36"

  name = "${var.application}-webserver"
  # Launch configuration
  lc_name         = "${var.application}-fe-launchconfig"
  image_id        = data.aws_ami.ewf_fe.id
  instance_type   = var.fe_instance_size
  security_groups = [module.ewf_fe_asg_security_group.this_security_group_id]
  root_block_device = [
    {
      volume_size = "40"
      volume_type = "gp2"
      encrypted   = true
    },
  ]
  # Auto scaling group
  asg_name                       = "${var.application}-fe-asg"
  vpc_zone_identifier            = data.aws_subnet_ids.web.ids
  health_check_type              = "ELB"
  min_size                       = var.fe_min_size
  max_size                       = var.fe_max_size
  desired_capacity               = var.fe_desired_capacity
  health_check_grace_period      = 300
  wait_for_capacity_timeout      = 0
  force_delete                   = true
  enable_instance_refresh        = true
  refresh_min_healthy_percentage = 50
  refresh_triggers               = ["launch_configuration"]
  key_name                       = aws_key_pair.ewf_keypair.key_name
  termination_policies           = ["OldestLaunchConfiguration"]
  target_group_arns              = concat(module.ewf_external_alb.target_group_arns, module.ewf_internal_alb.target_group_arns)
  iam_instance_profile           = module.ewf_fe_profile.aws_iam_instance_profile.name
  user_data_base64               = data.template_cloudinit_config.fe_userdata_config.rendered

  tags_as_map = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-FE-Support"
    )
  )

  depends_on = [
    module.ewf_external_alb,
    module.ewf_internal_alb
  ]
}