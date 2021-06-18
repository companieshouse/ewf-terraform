# ------------------------------------------------------------------------------
# RDS Security Group and rules
# ------------------------------------------------------------------------------
module "ewf_rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-rds-001"
  description = "Security group for the ${var.application} rds database"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks = local.rds_ingress_cidrs
  ingress_rules       = ["oracle-db-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5500
      to_port     = 5500
      protocol    = "tcp"
      description = "Oracle Enterprise Manager"
      cidr_blocks = join(",", local.rds_ingress_cidrs)
    }
  ]
  ingress_with_source_security_group_id = [
    {
      from_port                = 1521
      to_port                  = 1521
      protocol                 = "tcp"
      description              = "Frontend Tuxedo"
      source_security_group_id = data.aws_security_group.tuxedo.id
    },
    {
      from_port                = 1521
      to_port                  = 1521
      protocol                 = "tcp"
      description              = "Frontend Admin sites"
      source_security_group_id = data.aws_security_group.adminsites.id
    }
  ]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "oracle-db-tcp"
      source_security_group_id = module.ewf_fe_asg_security_group.this_security_group_id
      description              = "Allow frontends to connect to RDS"
    },
    {
      rule                     = "oracle-db-tcp"
      source_security_group_id = module.ewf_bep_asg_security_group.this_security_group_id
      description              = "Allow backend to connect to RDS"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  egress_rules = ["all-all"]
}

# ------------------------------------------------------------------------------
# RDS EWF
# ------------------------------------------------------------------------------
module "ewf_rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.23.0" # Pinned version to ensure updates are a choice, can be upgraded if new features are available and required.

  create_db_parameter_group = "true"
  create_db_subnet_group    = "true"

  identifier                 = join("-", ["rds", var.application, var.environment, "001"])
  engine                     = "oracle-se2"
  major_engine_version       = var.major_engine_version
  engine_version             = var.engine_version
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  license_model              = var.license_model
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  multi_az                   = var.multi_az
  storage_encrypted          = true
  kms_key_id                 = data.aws_kms_key.rds.arn

  name     = upper(var.application)
  username = local.ewf_rds_data["admin-username"]
  password = local.ewf_rds_data["admin-password"]
  port     = "1521"

  deletion_protection       = true
  maintenance_window        = var.rds_maintenance_window
  backup_window             = var.rds_backup_window
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = "false"
  final_snapshot_identifier = "${var.application}-final-deletion-snapshot"
  publicly_accessible       = false

  # Enhanced Monitoring
  monitoring_interval             = "30"
  monitoring_role_arn             = data.aws_iam_role.rds_enhanced_monitoring.arn
  enabled_cloudwatch_logs_exports = var.rds_log_exports

  performance_insights_enabled          = var.environment == "live" ? true : false
  performance_insights_kms_key_id       = data.aws_kms_key.rds.arn
  performance_insights_retention_period = 7

  # RDS Security Group
  vpc_security_group_ids = [
    module.ewf_rds_security_group.this_security_group_id,
    data.aws_security_group.rds_shared.id
  ]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.data.ids

  # DB Parameter group
  family = join("-", ["oracle-se2", var.major_engine_version])

  parameters = var.parameter_group_settings

  options = [
    {
      option_name                    = "OEM"
      port                           = "5500"
      vpc_security_group_memberships = [module.ewf_rds_security_group.this_security_group_id]
    },
    {
      option_name = "JVM"
    },
    {
      option_name = "SQLT"
      version     = "2018-07-25.v1"
      option_settings = [
        {
          name  = "LICENSE_PACK"
          value = "N"
        },
      ]
    },
    {
      option_name = "Timezone"
      option_settings = [
        {
          name  = "TIME_ZONE"
          value = "Europe/London"
        },
      ]
    },
  ]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", "${upper(var.application)}-DBA-Support"
    )
  )
}
