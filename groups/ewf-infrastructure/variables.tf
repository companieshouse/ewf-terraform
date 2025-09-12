# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "public_allow_cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "cidr block for allowing inbound users from internet"
}

variable "enable_sns_topic" {
  type        = bool
  description = "A boolean value to alter deployment of an SNS topic for CloudWatch actions"
  default     = false
}

# ------------------------------------------------------------------------------
# NFS Variables
# ------------------------------------------------------------------------------

variable "nfs_server" {
  type        = string
  description = "The name or IP of the environment specific NFS server"
  default     = null
}

variable "nfs_mount_destination_parent_dir" {
  type        = string
  description = "The parent folder that all NFS shares should be mounted inside on the EC2 instance"
  default     = "/mnt"
}

variable "nfs_mounts" {
  type        = map(any)
  description = "A map of objects which contains mount details for each mount path required."
  default = {
    SH_NFSTest = {                  # The name of the NFS Share from the NFS Server
      local_mount_point = "folder", # The name of the local folder to mount to if the share name is not wanted
      mount_options = [             # Traditional mount options as documented for any NFS Share mounts
        "rw",
        "wsize=8192"
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# RDS Variables
# ------------------------------------------------------------------------------
variable "instance_class" {
  type        = string
  description = "The type of instance for the RDS"
  default     = "db.t3.medium"
}

variable "multi_az" {
  type        = bool
  description = "Whether the RDS is Multi-AZ"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "The number of days to retain backups for - 0 to 35"
}

variable "allocated_storage" {
  type        = number
  description = "The amount of storage in GB to launch RDS with"
}

variable "maximum_storage" {
  type        = number
  description = "The maximum storage in GB to allow RDS to scale to"
}

variable "parameter_group_settings" {
  type        = list(any)
  description = "A list of parameters that will be set in the RDS instance parameter group"
}

variable "option_group_settings" {
  type        = any
  description = "A list of options that will be set in the RDS instance option group"
}

variable "rds_cloud_access" {
  type        = map(any)
  description = "A map of CIDR blocks names and values from Cloud sources that will be allowed access to RDS"
  default     = {}
}

variable "rds_concourse_access" {
  type        = bool
  description = "A boolean value indicating whether to allow Concourse ingress to the RDS database"
  default     = false
}

variable "rds_onpremise_access" {
  type        = list(any)
  description = "A list of cidr ranges that will be allowed access to RDS"
  default     = []
}

variable "rds_ingress_groups" {
  type        = list(string)
  description = "A list of security group name patterns that will be allowed access to RDS"
  default     = []
}

variable "rds_log_exports" {
  type        = list(string)
  description = "A list log types to export from RDS to Cloudwatch"
  default     = []
}

variable "rds_maintenance_window" {
  type        = string
  description = "A maintenance window that will allow AWS to run maintenance on underlying hosts e.g. `Mon:00:00-Mon:03:00`"
}

variable "rds_backup_window" {
  type        = string
  description = "A backup window that allows AWS to backup your RDS instance e.g. `03:00-06:00`"
}

variable "rds_schedule_enable" {
  type        = bool
  description = "Controls whether a start/stop schedule will be created for the RDS instance (true) or not (false)"
  default     = false
}

variable "rds_start_schedule" {
  type        = string
  description = "The SSM cron expression that defines when the RDS instance will be started"
  default     = ""
}

variable "rds_stop_schedule" {
  type        = string
  description = "The SSM cron expression that defines when the RDS instance will be stopped"
  default     = ""
}

# ------------------------------------------------------------------------------
# RDS CloudWatch Alarm Variables
# ------------------------------------------------------------------------------
variable "alarm_actions_enabled" {
  type        = bool
  description = "Defines whether SNS-based alarm actions should be enabled (true) or not (false) for alarms"
}

variable "alarm_topic_name" {
  type        = string
  description = "The name of the SNS topic to use for in-hours alarm notifications and clear notifications"
}

variable "alarm_topic_name_ooh" {
  type        = string
  description = "The name of the SNS topic to use for OOH alarm notifications"
}

# ------------------------------------------------------------------------------
# RDS Engine Type Variables
# ------------------------------------------------------------------------------
variable "major_engine_version" {
  type        = string
  description = "The major version of the database engine type e.g. 12.1"
}
variable "engine_version" {
  type        = string
  description = "The engine version provided by AWS RDS e.g. 12.1.0.2.v21"
}
variable "license_model" {
  type        = string
  description = "The license model for the engine, byol or license-include: https://aws.amazon.com/rds/oracle/faqs/"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "True/False value to allow AWS to apply minor version updates to RDS without approval from owner"
}

# ------------------------------------------------------------------------------
# EWF Frontend Variables - ALB 
# ------------------------------------------------------------------------------

variable "fe_service_port" {
  type        = number
  default     = 80
  description = "Target group backend port"
}

variable "fe_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

variable "fe_default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "fe_app_release_version" {
  type        = string
  description = "Version of the application to download for deployment to frontend server(s)"
}

variable "fe_ami_name" {
  type        = string
  default     = "ewf-frontend-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for frontend server(s)"
}

variable "fe_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "fe_min_size" {
  type        = number
  description = "The min size of the ASG"
}

variable "fe_max_size" {
  type        = number
  description = "The max size of the ASG"
}

variable "fe_desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "fe_cw_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}

variable "fe_access_cidrs" {
  type        = list(any)
  description = "List of additional CIDRs requiring access via the internal ALB"
  default     = []
}

# ------------------------------------------------------------------------------
# EWF Backend Variables
# ------------------------------------------------------------------------------

variable "bep_default_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Total days to retain logs in CloudWatch log group if not specified for specific logs"
}

variable "bep_app_release_version" {
  type        = string
  description = "Version of the application to download for deployment to backend server(s)"
}

variable "bep_ami_name" {
  type        = string
  default     = "ewf-frontend-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for backend server(s)"
}

variable "bep_instance_size" {
  type        = string
  description = "The size of the ec2 instances to build"
}

variable "bep_min_size" {
  type        = number
  description = "The min size of the ASG"
}

variable "bep_max_size" {
  type        = number
  description = "The max size of the ASG"
}

variable "bep_desired_capacity" {
  type        = number
  description = "The desired capacity of ASG"
}

variable "bep_cw_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}
