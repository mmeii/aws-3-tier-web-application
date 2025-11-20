# Database Module

Builds a secure Amazon RDS instance plus the necessary subnet and security groups so only the application tier can reach the database. Supports PostgreSQL/MySQL variants, encryption, backups, multi-AZ, and deletion protection toggles.

## Usage

```hcl
module "database" {
  source                = "./modules/database"
  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  db_subnet_ids         = module.network.db_subnet_ids
  app_security_group_id = module.application.app_security_group_id
  engine                = "postgres"
  engine_version        = "15.3"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  username              = "appuser"
  password              = var.db_password
  publicly_accessible   = false
  storage_encrypted     = true
}
```

## Terraform Docs

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_security_group.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated_storage](#input_allocated_storage) | n/a | `number` | n/a | yes |
| <a name="input_app_security_group_id"></a> [app_security_group_id](#input_app_security_group_id) | n/a | `string` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply_immediately](#input_apply_immediately) | n/a | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup_retention_period](#input_backup_retention_period) | n/a | `number` | n/a | yes |
| <a name="input_db_subnet_ids"></a> [db_subnet_ids](#input_db_subnet_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion_protection](#input_deletion_protection) | n/a | `bool` | n/a | yes |
| <a name="input_engine"></a> [engine](#input_engine) | n/a | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version) | n/a | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input_environment) | n/a | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance_class](#input_instance_class) | n/a | `string` | n/a | yes |
| <a name="input_max_allocated_storage"></a> [max_allocated_storage](#input_max_allocated_storage) | n/a | `number` | n/a | yes |
| <a name="input_multi_az"></a> [multi_az](#input_multi_az) | n/a | `bool` | n/a | yes |
| <a name="input_password"></a> [password](#input_password) | n/a | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input_port) | n/a | `number` | `0` | no |
| <a name="input_project_name"></a> [project_name](#input_project_name) | n/a | `string` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly_accessible](#input_publicly_accessible) | n/a | `bool` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip_final_snapshot](#input_skip_final_snapshot) | n/a | `bool` | `true` | no |
| <a name="input_storage_encrypted"></a> [storage_encrypted](#input_storage_encrypted) | n/a | `bool` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_username"></a> [username](#input_username) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output_endpoint) | n/a |
| <a name="output_port"></a> [port](#output_port) | n/a |
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id) | n/a |
<!-- END_TF_DOCS -->
