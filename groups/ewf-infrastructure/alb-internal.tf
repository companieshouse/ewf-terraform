# ------------------------------------------------------------------------------
# EWF Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_internal_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-internal-alb-001"
  description = "Security group for the ${var.application} web servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      description = "Application Access"
      cidr_blocks = join(",", local.fe_alb_app_access)
    },
    {
      rule        = "https-443-tcp"
      description = "Application Access"
      cidr_blocks = join(",", local.fe_alb_app_access)
    }
  ]

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = data.aws_security_group.identity_gateway.id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = data.aws_security_group.identity_gateway.id
    }
  ]

  egress_rules = ["all-all"]
}

#--------------------------------------------
# Internal ALB EWF
#--------------------------------------------
module "ewf_internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name                       = "alb-${var.application}-internal-001"
  vpc_id                     = data.aws_vpc.vpc.id
  internal                   = true
  load_balancer_type         = "application"
  enable_deletion_protection = true

  security_groups = [module.ewf_internal_alb_security_group.this_security_group_id]
  subnets         = data.aws_subnet_ids.web.ids

  access_logs = {
    bucket  = local.elb_access_logs_bucket_name
    prefix  = local.elb_access_logs_prefix
    enabled = true
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
      action_type        = "redirect"
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
      certificate_arn    = data.aws_acm_certificate.acm_cert.arn
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name                 = "tg-${var.application}-internal-001"
      backend_protocol     = "HTTP"
      backend_port         = var.fe_service_port
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = var.fe_health_check_path
        port                = var.fe_service_port
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags = {
        InstanceTargetGroupTag = var.application
      }
    },
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-DBA-Support"
    )
  )
}

resource "aws_lb_listener_rule" "redirects_internal" {
  listener_arn = module.ewf_internal_alb.https_listener_arns[0]
  priority     = 10

  action {
    type          = "redirect"

    redirect {
      path        = "/"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = [
        "/account*",
        "/password-recovery*"
      ]
    }
  }
}

#--------------------------------------------
# Internal ALB CloudWatch Alarms
#--------------------------------------------
module "ewf_internal_alb_alarms" {
  source = "git@github.com:companieshouse/terraform-modules//aws/alb-cloudwatch-alarms?ref=tags/1.0.116"

  alb_arn_suffix            = module.ewf_internal_alb.this_lb_arn_suffix
  target_group_arn_suffixes = module.ewf_internal_alb.target_group_arn_suffixes

  prefix                    = "ewf-internal-frontend-"
  response_time_threshold   = "100"
  evaluation_periods        = "3"
  statistic_period          = "60"
  maximum_4xx_threshold     = "2"
  maximum_5xx_threshold     = "2"
  unhealthy_hosts_threshold = "1"

  # If actions are used then all alarms will have these applied, do not add any actions which you only want to be used for specific alarms
  # The module has lifecycle hooks to ignore changes via the AWS Console so in this use case the alarm can be modified there.
  actions_alarm = var.enable_sns_topic ? [module.cloudwatch_sns_notifications[0].sns_topic_arn] : []
  actions_ok    = var.enable_sns_topic ? [module.cloudwatch_sns_notifications[0].sns_topic_arn] : []

  depends_on = [
    module.cloudwatch_sns_notifications,
    module.ewf_internal_alb
  ]
}
