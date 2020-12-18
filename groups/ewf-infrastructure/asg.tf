# ASG Module
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name = "ewf-webserver"
  # Launch configuration
  lc_name = "ewf-launchconfig"
  image_id          = data.aws_ami.ewf.id
  instance_type     = "t2.micro"
  security_groups   = [module.ewf_alb_security_group.this_security_group_id]
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
  asg_name                  = "ewf-asg"
  depends_on                = [module.ewf_alb]
  vpc_zone_identifier       = data.aws_subnet_ids.data.ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  wait_for_capacity_timeout = 0
  force_delete              = true
  target_group_arns         = module.ewf_alb.target_group_arns
  tags = [
    {
      key                 = "Name"
      value               = "ewf web instance"
      propagate_at_launch = true
    }
  ] 
}