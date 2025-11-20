module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  az_count            = var.az_count
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  tags                = local.common_tags
}

module "application" {
  source = "./modules/application"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  app_subnet_ids        = module.network.app_subnet_ids
  alb_ingress_cidrs     = var.alb_ingress_cidrs
  instance_type         = var.app_instance_type
  desired_capacity      = var.app_desired_capacity
  min_size              = var.app_min_size
  max_size              = var.app_max_size
  app_port              = var.app_port
  health_check_path     = var.app_health_check_path
  user_data             = var.app_user_data
  additional_user_data  = var.extra_app_user_data
  enable_https_listener = var.enable_https_listener
  certificate_arn       = var.certificate_arn
  tags                  = local.common_tags
}

module "database" {
  count = var.enable_database ? 1 : 0

  source = "./modules/database"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.network.vpc_id
  db_subnet_ids           = module.network.db_subnet_ids
  app_security_group_id   = module.application.app_security_group_id
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention
  publicly_accessible     = var.db_publicly_accessible
  storage_encrypted       = var.db_storage_encrypted
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = var.db_skip_final_snapshot
  apply_immediately       = var.db_apply_immediately
  tags                    = local.common_tags
}

check "https_listener_certificate" {
  assert {
    condition     = var.enable_https_listener == false || (var.certificate_arn != null && var.certificate_arn != "")
    error_message = "certificate_arn must be provided when enable_https_listener is true."
  }
}
