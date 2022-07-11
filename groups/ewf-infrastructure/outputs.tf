output "ewf_frontend_address_internal" {
  value = aws_route53_record.ewf_alb_internal.fqdn
}

output "ewf_backend_address_internal" {
  value = aws_route53_record.ewf_bep_alb_internal.fqdn
}

output "rds_address" {
  value = aws_route53_record.ewf_rds.fqdn
}
