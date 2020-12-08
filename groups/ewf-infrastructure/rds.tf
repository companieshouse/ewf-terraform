# ------------------------------------------------------------------------------
# RDS Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-rds-001"
  description = "Security group for the ${var.application} rds database"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.admin_cidrs
  ingress_rules       = ["oracle-db-tcp"]
  egress_rules        = ["all-all"]
}

# ------------------------------------------------------------------------------
# RDS EWF
# ------------------------------------------------------------------------------
module "ewf_rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  create_db_parameter_group = "true"
  create_db_subnet_group    = "true"

  identifier           = join("-", ["rds", var.application, var.environment, "001"])
  engine               = var.engine
  major_engine_version = var.major_engine_version
  engine_version       = var.engine_version
  license_model        = var.license_model
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  multi_az             = var.multi_az
  storage_encrypted    = true
  kms_key_id           = data.aws_kms_key.rds.arn

  name     = upper(var.application)
  username = local.ewf_rds_data["admin-username"]
  password = local.ewf_rds_data["admin-password"]
  port     = "1521"

  deletion_protection       = true
  maintenance_window        = "Mon:00:00-Mon:03:00"
  backup_window             = "03:00-06:00"
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = "false"
  final_snapshot_identifier = "${var.application}-final-deletion-snapshot"

  # Enhanced Monitoring
  monitoring_interval = "30"
  monitoring_role_arn = data.aws_iam_role.rds_enhanced_monitoring.arn

  # RDS Security Group
  vpc_security_group_ids = [module.ewf_rds_security_group.this_security_group_id]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.data.ids

  # DB Parameter group
  family = join("-", [var.engine, var.major_engine_version])

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-DBA-Support"
    )
  )
}