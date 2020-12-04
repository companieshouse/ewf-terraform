# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  vpc_data     = data.vault_generic_secret.vpc.data
  admin_cidrs  = values(data.vault_generic_secret.internal_cidrs.data)
  route53_data = data.vault_generic_secret.route53.data
  kms_data     = data.vault_generic_secret.kms.data
  ewf_rds_data = data.vault_generic_secret.ewf_rds.data

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}