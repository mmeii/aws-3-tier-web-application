locals {
  common_tags = merge({
    Project     = var.project_name
    Environment = var.environment
  }, var.additional_tags)
}
