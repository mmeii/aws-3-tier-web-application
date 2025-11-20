variable "aws_region" {
  description = "AWS region to deploy the stack into."
  type        = string
}

variable "aws_profile" {
  description = "Optional AWS CLI profile name to use for authentication."
  type        = string
  default     = null
}

variable "project_name" {
  description = "Short name for the project used in tags and resource names."
  type        = string
}

variable "environment" {
  description = "Environment label (dev, staging, prod, etc.)."
  type        = string
}

variable "additional_tags" {
  description = "Optional additional tags to apply to supported resources."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to span."
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "Optional list of CIDR blocks for public subnets. Leave null to auto-calculate."
  type        = list(string)
  default     = null
}

variable "app_subnet_cidrs" {
  description = "Optional list of CIDR blocks for application subnets. Leave null to auto-calculate."
  type        = list(string)
  default     = null
}

variable "db_subnet_cidrs" {
  description = "Optional list of CIDR blocks for database subnets. Leave null to auto-calculate."
  type        = list(string)
  default     = null
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the public load balancer."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_instance_type" {
  description = "EC2 instance type for the application tier."
  type        = string
  default     = "t3.micro"
}

variable "app_desired_capacity" {
  description = "Desired number of application instances."
  type        = number
  default     = 2
}

variable "app_min_size" {
  description = "Minimum number of application instances in the ASG."
  type        = number
  default     = 1
}

variable "app_max_size" {
  description = "Maximum number of application instances in the ASG."
  type        = number
  default     = 4
}

variable "app_port" {
  description = "Port where the application listens inside the instance."
  type        = number
  default     = 80
}

variable "app_health_check_path" {
  description = "Health check path for the target group."
  type        = string
  default     = "/"
}

variable "app_user_data" {
  description = "Optional shell user data script for compute instances. Leave null to use the module default sample app."
  type        = string
  default     = null
}

variable "extra_app_user_data" {
  description = "Additional shell commands appended to the default user data script."
  type        = string
  default     = ""
}

variable "enable_https_listener" {
  description = "Whether to create an HTTPS listener on the ALB."
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener. Required when enable_https_listener is true."
  type        = string
  default     = null
}

variable "enable_database" {
  description = "Set to false to skip provisioning the database tier."
  type        = bool
  default     = true
}

variable "db_engine" {
  description = "Database engine (postgres, mysql, etc.)."
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version."
  type        = string
  default     = "15.3"
}

variable "db_port" {
  description = "Port for the database listener. Defaults to standard engine port."
  type        = number
  default     = 5432
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial storage allocation for the database in GB."
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum storage autoscaling size for the database in GB."
  type        = number
  default     = 100
}

variable "db_username" {
  description = "Master username for the database."
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Master password for the database."
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Enable multi-AZ deployment for RDS."
  type        = bool
  default     = false
}

variable "db_backup_retention" {
  description = "Backup retention period in days."
  type        = number
  default     = 7
}

variable "db_publicly_accessible" {
  description = "Whether the DB instance has a public endpoint. Keep false for production."
  type        = bool
  default     = false
}

variable "db_storage_encrypted" {
  description = "Enable storage encryption for the DB instance."
  type        = bool
  default     = true
}

variable "db_deletion_protection" {
  description = "Protect the database from accidental deletion."
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot on destroy. Disable to retain a backup."
  type        = bool
  default     = true
}

variable "db_apply_immediately" {
  description = "Apply database changes immediately instead of waiting for the next maintenance window."
  type        = bool
  default     = true
}
