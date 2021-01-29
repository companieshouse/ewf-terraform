resource "aws_route53_record" "ewf_rds" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = "${var.application}db"
  type    = "CNAME"
  ttl     = "300"
  records = [module.ewf_rds.this_db_instance_address]
}

resource "aws_route53_record" "ewf_alb_internal" {
  zone_id = data.aws_route53_zone.private_zone.zone_id
  name    = var.application
  type    = "CNAME"
  ttl     = "300"
  records = [module.ewf_internal_alb.this_lb_dns_name]
}