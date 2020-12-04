resource "aws_route53_record" "ewf_rds" {
  zone_id = local.route53_data["route53-zone-id"]
  name    = "${var.application}db"
  type    = "CNAME"
  ttl     = "300"
  records = [module.ewf_rds.this_db_instance_address]
}