data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-data-*"]
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

data "aws_security_group" "rds_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-rds-shared-001*"]
  }
}

# data "aws_security_group" "tuxedo" {
#   filter {
#     name   = "tag:Name"
#     values = ["ewf-frontend-tuxedo-${var.environment}"]
#   }
# }

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

data "vault_generic_secret" "ewf_rds_data" {
  path = "applications/${var.aws_profile}/${var.application}/rds"
}

data "vault_generic_secret" "ewf_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/ec2"
}

data "vault_generic_secret" "ewf_frontend_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/${var.application}/frontend"
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
}

data "aws_ami" "ewf" {
  owners      = [data.vault_generic_secret.account_ids.data["development"]]
  most_recent = var.frontend_ami_name == "ewf-frontend-*" ? true : false

  filter {
    name = "name"
    values = [
      var.frontend_ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

# data "template_file" "frontend_userdata" {
#   template = file("${path.module}/templates/user_data.tpl")

#   vars = {
#     REGION                    = var.aws_region
#     LOG_GROUP_NAME            = "logs-${var.application}-frontend"
#     EWF_FRONTEND_INPUTS       = local.ewf_frontend_data
#     ANSIBLE_PLAYBOOK_REPO     = "https://github.com/companieshouse/ewf-ami.git"
#     ANSIBLE_PLAYBOOK_LOCATION = "deployment-scripts/frontend_deployment.yml"
#     ANSIBLE_INPUTS            = jsonencode(local.ewf_frontend_ansible_inputs)
#   }
# }

# data "template_cloudinit_config" "frontend_userdata_config" {
#   gzip          = true
#   base64_encode = true

#   part {
#     content_type = "text/x-shellscript"
#     content      = data.template_file.frontend_userdata.rendered
#   }

# }
