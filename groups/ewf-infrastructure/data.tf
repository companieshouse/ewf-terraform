data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-public-*"]
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-web-*"]
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-data-*"]
  }
}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "rds_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-rds-shared-001*"]
  }
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_security_group" "rds_ingress" {
  count = length(var.rds_ingress_groups)
  filter {
    name   = "group-name"
    values = [var.rds_ingress_groups[count.index]]
  }
}

data "aws_security_group" "identity_gateway" {
  name = "identity-gateway-instance"
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "aws_iam_role" "rds_enhanced_monitoring" {
  name = "irol-rds-enhanced-monitoring"
}

data "aws_kms_key" "rds" {
  key_id = "alias/kms-rds"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "s3_releases" {
  path = "aws-accounts/shared-services/s3"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "chs_vpc_subnets" {
  path = "aws-accounts/${var.environment}/vpc/subnets"
}

data "vault_generic_secret" "ewf_rds_data" {
  path = "applications/${var.aws_profile}/${var.application}/rds"
}

data "vault_generic_secret" "ewf_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/ec2"
}

data "vault_generic_secret" "ewf_fe_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/frontend"
}

data "vault_generic_secret" "ewf_bep_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/backend"
}

data "vault_generic_secret" "ewf_bep_cron_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/cron"
}

data "vault_generic_secret" "ewf_fess_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/fess"
}

data "aws_acm_certificate" "acm_cert" {
  domain      = var.domain_name
  most_recent = true
}

# ------------------------------------------------------------------------------
# EWF Frontend data
# ------------------------------------------------------------------------------
data "aws_ami" "ewf_fe" {
  owners      = [local.account_ids["development"]]
  most_recent = var.fe_ami_name == "ewf-frontend-*" ? true : false

  filter {
    name = "name"
    values = [
      var.fe_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "fe_userdata" {
  template = file("${path.module}/templates/fe_user_data.tpl")

  vars = {
    REGION                    = var.aws_region
    HERITAGE_ENVIRONMENT      = title(var.environment)
    APP_VERSION               = var.fe_app_release_version
    EWF_FRONTEND_INPUTS_PATH  = "${local.parameter_store_path_prefix}/frontend_inputs"
    ANSIBLE_INPUTS_PATH       = "${local.parameter_store_path_prefix}/frontend_ansible_inputs"
  }
}

data "template_cloudinit_config" "fe_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.fe_userdata.rendered
  }

}

# ------------------------------------------------------------------------------
# EWF Backend data
# ------------------------------------------------------------------------------
data "aws_ami" "ewf_bep" {
  owners      = [local.account_ids["development"]]
  most_recent = var.bep_ami_name == "ewf-frontend-*" ? true : false

  filter {
    name = "name"
    values = [
      var.bep_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "template_file" "ewf_cron_file" {
  template = file("${path.module}/templates/${var.aws_profile}/bep_cron.tpl")

  vars = {
    USER     = data.vault_generic_secret.ewf_bep_cron_data.data["username"]
    PASSWORD = data.vault_generic_secret.ewf_bep_cron_data.data["password"]
  }
}

data "template_file" "bep_userdata" {
  template = file("${path.module}/templates/bep_user_data.tpl")

  vars = {
    REGION                  = var.aws_region
    HERITAGE_ENVIRONMENT    = title(var.environment)
    APP_VERSION             = var.bep_app_release_version
    EWF_BACKEND_INPUTS_PATH = "${local.parameter_store_path_prefix}/backend_inputs"
    ANSIBLE_INPUTS_PATH     = "${local.parameter_store_path_prefix}/backend_ansible_inputs"
    EWF_CRON_ENTRIES_PATH   = "${local.parameter_store_path_prefix}/backend_cron_entries"
    EWF_FESS_TOKEN_PATH     = "${local.parameter_store_path_prefix}/backend_fess_token"
  }
}

data "template_cloudinit_config" "bep_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.bep_userdata.rendered
  }

}
