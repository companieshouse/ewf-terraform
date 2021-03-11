# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs  = values(data.vault_generic_secret.internal_cidrs.data)
  s3_releases  = data.vault_generic_secret.s3_releases.data
  ewf_rds_data = data.vault_generic_secret.ewf_rds_data.data
  ewf_fe_data  = data.vault_generic_secret.ewf_fe_data.data_json
  ewf_bep_data = data.vault_generic_secret.ewf_bep_data.data_json
  ewf_ec2_data = data.vault_generic_secret.ewf_ec2_data.data

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  rds_ingress_cidrs = concat(local.admin_cidrs, var.rds_onpremise_access)
  
  #For each log map passed, add an extra kv for the log group name
  fe_cw_logs = { for log, map in var.fe_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-fe-${log}" }) }
  bep_cw_logs  = { for log, map in var.bep_cw_logs : log => merge(map, { "log_group_name" = "${var.application}-bep-${log}" }) }

  fe_log_groups = compact([ for log, map in local.fe_cw_logs : lookup(map, "log_group_name", "") ])
  bep_log_groups = compact([ for log, map in local.bep_cw_logs : lookup(map, "log_group_name", "") ])

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
  }

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
  }
}