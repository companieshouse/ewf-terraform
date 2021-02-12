# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs       = values(data.vault_generic_secret.internal_cidrs.data)
  s3_releases       = data.vault_generic_secret.s3_releases.data
  ewf_rds_data      = data.vault_generic_secret.ewf_rds_data.data
  ewf_frontend_data = data.vault_generic_secret.ewf_frontend_data.data
  ewf_ec2_data      = data.vault_generic_secret.ewf_ec2_data.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  rds_ingress_cidrs = concat(local.admin_cidrs, var.rds_onpremise_access)

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}