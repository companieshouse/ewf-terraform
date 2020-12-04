data "vault_generic_secret" "vpc" {
  path = "aws-accounts/${var.aws_account}/vpc"
}

data "vault_generic_secret" "route53" {
  path = "aws-accounts/${var.aws_account}/route-53"
}

data "vault_generic_secret" "kms" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "ewf_rds" {
  path = "applications/${var.aws_profile}/${var.application}/rds"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}