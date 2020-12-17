# ------------------------------------------------------------------------------
# EWF Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_web_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-web-001"
  description = "Security group for the ${var.application} web servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["ewf-web-tcp"]
  egress_rules        = ["all-all"]
}

#--------------------------------------------
# ALB EWF
#--------------------------------------------
module "ewf_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "EWF-ALB"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.ewf_web_security_group.id]
  subnets         = data.aws_subnet_ids.data.ids

  # Accessing logs to S3
  access_logs {
    bucket = aws_s3_bucket.alb_logs.bucket # Does this exist ?
    prefix = "ewf-alb"
  }

  tags {
    Name        = "EWFWeb"
    Environment = "Test"
  }
}

#--------------------------------------------
# Launch Configuration 
#--------------------------------------------
resource "aws_launch_configuration" "ewf-launchconfig" {
  name = "ewf-launchconfig"
  depends_on    = [module.ewf_web_security_group]
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  security_groups = [module.ewf_web_security_group.id]

  lifecycle {
    create_before_destroy = true
  }
}

#--------------------------------------------
# Auto Scaling Group
#--------------------------------------------
resource "aws_autoscaling_group" "ewf-asg" {
  name                      = "ewf-asg"
  depends_on                = [aws_launch_configuration.ewf-launchconfig]
  vpc_zone_identifier       = data.aws_subnet_ids.data.ids
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = [module.ewf_alb.name]
  force_delete              = true
  launch_configuration      = aws_launch_configuration.ewf-launchconfig.id
  target_group_arns         = [aws_lb_target_group.ewf-tg.arn]

  tags = {
    key                 = "Name"
    value               = "ewf web instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#--------------------------------------------
# Target Group
#--------------------------------------------
resource "aws_lb_target_group" "ewf-tg" {
  name        = "ewf-tg"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = "instance"
  # Health Checks  
  health_check {
    interval            = 30
    path                = "/healthcheck"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200,202"
  }
}

#-----------------------------------------------------
# Assignment of the EWF instances to the target group
#-----------------------------------------------------
resource "aws_lb_target_group_attachment" "ewf-alb-target-attachement" {
  target_group_arn = aws_lb_target_group.ewf-tg.arn
  #   target_id        = aws_instance.ewf-web.id
  target_id = aws_instance.ewf-web.id
  port      = 80
}

#--------------------------------------------
# ALB Listener
#--------------------------------------------
resource "aws_lb_listener" "ewf-alb-listener" {

  depends_on        = [aws_lb_target_group.ewf-tg.id]
  load_balancer_arn = module.ewf_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "EWFWebSecurityPolicy"
  #   certificate_arn	    = aws_iam_server_certificate.ewf_web_certs.arn
  default_action {
    target_group_arn = aws_lb_target_group.ewf-tg.arn
    type             = "forward"
  }
}

#--------------------------------------------
# ALB CloudWatch Merics
#--------------------------------------------
module "alb_metrics" {
  source = "../../../terraform-modules/aws/alb-metrics"

  load_balancer_id = module.alb.this_lb_id
  target_group_ids = module.alb.target_group_arns

  depends_on = [module.ewf_alb]
}