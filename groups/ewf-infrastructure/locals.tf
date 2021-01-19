# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs  = values(data.vault_generic_secret.internal_cidrs.data)
  ewf_rds_data = data.vault_generic_secret.ewf_rds.data
  ewf_tnsnames = jsondecode(local.ewf_rds_data["tnsnames"])
  ewf_ec2_data = data.vault_generic_secret.ewf_ec2_data.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  tns_connections = {
    servers = [for connection in local.ewf_tnsnames.tnsnames : {
      name         = connection.name,
      address      = connection.address
      service_name = connection.service_name
      port         = connection.port
      }
    ]
  }

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}