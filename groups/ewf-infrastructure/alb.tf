data "aws_route53_zone" "this" {
  name = local.domain_name
}

# ------------------------------------------------------------------------------
# EWF Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-alb-001"
  description = "Security group for the ${var.application} web servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

# AWS ACM Module
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.0"

  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.this.id
}

#--------------------------------------------
# ALB EWF
#--------------------------------------------
module "ewf_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "alb-${var.application}-001"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.ewf_alb_security_group.this_security_group_id]
  subnets         = data.aws_subnet_ids.data.ids

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.this_acm_certificate_arn
      target_group_index = 1
    },
  ]
  
  target_groups = [
    {
      name_prefix          = "h1"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/health"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = "ewf"
      }
    },
  ]

  tags = {
    Environment = "Test"
  }
}

#--------------------------------------------
# Launch Configuration 
#--------------------------------------------
# resource "aws_launch_configuration" "ewf-launchconfig" {
#   name = "ewf-launchconfig"
#   depends_on    = [module.ewf_alb_security_group]
#   image_id      = lookup(var.AMIS, var.AWS_REGION)
#   instance_type = "t2.micro"
#   security_groups = [module.ewf_alb_security_group.id]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

#--------------------------------------------
# Auto Scaling Group
#--------------------------------------------
# resource "aws_autoscaling_group" "ewf-asg" {
#   name                      = "ewf-asg"
#   depends_on                = [aws_launch_configuration.ewf-launchconfig]
#   vpc_zone_identifier       = data.aws_subnet_ids.data.ids
#   max_size                  = 2
#   min_size                  = 2
#   health_check_grace_period = 300
#   health_check_type         = "ELB"
#   load_balancers            = [module.ewf_alb.name]
#   force_delete              = true
#   launch_configuration      = aws_launch_configuration.ewf-launchconfig.id
#   target_group_arns         = [aws_lb_target_group.ewf-tg.arn]

#   tags = {
#     key                 = "Name"
#     value               = "ewf web instance"
#     propagate_at_launch = true
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

#--------------------------------------------
# Target Group
#--------------------------------------------
# resource "aws_lb_target_group" "ewf-tg" {
#   name        = "ewf-tg"
#   port        = 443
#   protocol    = "HTTPS"
#   vpc_id      = data.aws_vpc.vpc.id
#   target_type = "instance"
#   # Health Checks  
#   health_check {
#     interval            = 30
#     path                = "/healthcheck"
#     port                = 80
#     protocol            = "HTTP"
#     healthy_threshold   = 5
#     unhealthy_threshold = 2
#     timeout             = 5
#     matcher             = "200,202"
#   }
# }

#--------------------------------------------
# ALB Listener
#--------------------------------------------
# resource "aws_lb_listener" "ewf-alb-listener" {

#   load_balancer_arn = module.ewf_alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   ssl_policy        = "EWFALBSecurityPolicy"
#   #   certificate_arn	    = aws_iam_server_certificate.ewf_web_certs.arn
#   default_action {
#     target_group_arn = aws_lb_target_group.ewf-tg.arn
#     type             = "forward"
#   }
# }

#--------------------------------------------
# ALB CloudWatch Merics
#--------------------------------------------
module "alb_metrics" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-metrics"

  load_balancer_id = module.ewf_alb.this_lb_id
  target_group_ids = module.ewf_alb.target_group_arns

  depends_on = [module.ewf_alb]
}