# ------------------------------------------------------------------------------
# EWF Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_asg_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-asg-001"
  description = "Security group for the ${var.application} asg"
  vpc_id      = data.aws_vpc.vpc.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.ewf_alb_security_group.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules        = ["all-all"]
}

# ASG Module
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name    = "${var.application}-webserver"
  # Launch configuration
  lc_name         = "${var.application}-launchconfig"
  image_id        = data.aws_ami.ewf.id
  instance_type   = var.instance_size
  security_groups = [module.ewf_asg_security_group.this_security_group_id]
  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]
  # Auto scaling group
  asg_name                  = "${var.application}-asg"
  depends_on                = [module.ewf_alb]
  vpc_zone_identifier       = data.aws_subnet_ids.web.ids
  health_check_type         = "EC2"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  wait_for_capacity_timeout = 0
  force_delete              = true
  key_name                  = aws_key_pair.asg_keypair.key_name
  termination_policies      = ["OldestLaunchConfiguration"]
  target_group_arns         = module.ewf_alb.target_group_arns

  tags_as_map = merge(
    local.default_tags,
    map(
      "Name", "${var.application}-web-instance",
      "ServiceTeam", "${upper(var.application)}-EC2-Support"
    )
  )
}

resource "aws_key_pair" "asg_keypair" {
  key_name   = format("%s-%s", var.application, "asg")
  public_key = local.ewf_ec2_data["public-key"]
}