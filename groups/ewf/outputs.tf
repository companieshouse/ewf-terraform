output "rds_address" {
  value = aws_route53_record.ewf_rds.fqdn
}

output "rds_endpoint" {
  value = module.ewf_rds.this_db_instance_address
}

output "rds_database_name" {
  value = module.ewf_rds.this_db_instance_name
}