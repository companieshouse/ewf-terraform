locals {
  account_ids = data.vault_generic_secret.account_ids.data
  admin_cidrs  = values(data.vault_generic_secret.internal_cidrs.data)
  s3_releases  = data.vault_generic_secret.s3_releases.data
  ewf_ec2_data = data.vault_generic_secret.ewf_ec2_data.data
  ewf_rds_data = data.vault_generic_secret.ewf_rds_data.data
  ewf_fe_data  = data.vault_generic_secret.ewf_fe_data.data_json
  ewf_bep_data = data.vault_generic_secret.ewf_bep_data.data_json

  dba_dev_cidrs_list = jsondecode(data.vault_generic_secret.ewf_rds_data.data_json)["dba-dev-cidrs"]

  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  account_ssm_key_arn    = local.kms_keys_data["ssm"]
  logs_kms_key_id        = local.kms_keys_data["logs"]
  sns_kms_key_id         = local.kms_keys_data["sns"]
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  chs_app_subnets   = values(jsondecode(data.vault_generic_secret.chs_vpc_subnets.data["applications"]))
  fe_alb_app_access = concat(local.chs_app_subnets, var.fe_access_cidrs)

  rds_ingress_cidrs = concat(local.admin_cidrs, var.rds_onpremise_access)
  rds_ingress_from_services = flatten([
    for sg_data in data.aws_security_group.rds_ingress : {
      from_port                = 1521
      to_port                  = 1521
      protocol                 = "tcp"
      description              = "Access from ${sg_data.tags.Name}"
      source_security_group_id = sg_data.id
    }
  ])

  #For each log map passed, add an extra kv for the log group name
  fe_cw_logs  = { for log, map in var.fe_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-fe-${log}" }) }
  bep_cw_logs = { for log, map in var.bep_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-bep-${log}" }) }

  fe_log_groups  = compact([for log, map in local.fe_cw_logs : lookup(map, "log_group_name", "")])
  bep_log_groups = compact([for log, map in local.bep_cw_logs : lookup(map, "log_group_name", "")])

  ewf_fe_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    heritage_environment       = var.environment
    version                    = var.fe_app_release_version
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    region                     = var.aws_region
    cw_log_files               = local.fe_cw_logs
    cw_agent_user              = "root"
  }

  ewf_bep_ansible_inputs = {
    s3_bucket_releases         = local.s3_releases["release_bucket_name"]
    s3_bucket_configs          = local.s3_releases["config_bucket_name"]
    heritage_environment       = var.environment
    version                    = var.bep_app_release_version
    default_nfs_server_address = var.nfs_server
    mounts_parent_dir          = var.nfs_mount_destination_parent_dir
    mounts                     = var.nfs_mounts
    region                     = var.aws_region
    cw_log_files               = local.bep_cw_logs
    cw_agent_user              = "root"
  }

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }

  parameter_store_path_prefix = "/${var.application}/${var.environment}"
  
  parameter_store_secrets = {
    frontend_inputs         = local.ewf_fe_data
    frontend_ansible_inputs = jsonencode(local.ewf_fe_ansible_inputs)
    backend_inputs          = local.ewf_bep_data
    backend_ansible_inputs  = base64gzip(jsonencode(local.ewf_bep_ansible_inputs))
    backend_cron_entries    = base64gzip(data.template_file.ewf_cron_file.rendered)
    backend_fess_token      = data.vault_generic_secret.ewf_fess_data.data["fess_token"]
  }
}
