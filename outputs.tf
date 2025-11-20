output "vpc_id" {
  description = "ID of the provisioned VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.network.public_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = module.application.alb_dns_name
}

output "app_autoscaling_group_name" {
  description = "Name of the application Auto Scaling Group."
  value       = module.application.asg_name
}

output "database_endpoint" {
  description = "Writer endpoint of the database (if created)."
  value       = var.enable_database ? module.database[0].endpoint : null
  sensitive   = true
}
