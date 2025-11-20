# AWS 3-Tier Web Application MVP

This repository contains a reusable Terraform MVP that provisions a production-ready three-tier web application on AWS. It bootstraps networking, load balancing, compute, and data resources with opinionated defaults and exposes variables so teams can easily customize the stack for their workloads.

## Architecture Overview

```
Internet -> ALB (public subnets) -> EC2 ASG (private app subnets) -> RDS (isolated DB subnets)
                |                        |
                +----- NAT Gateway ------+
```

* **Network tier** – Creates a VPC with public, application, and database subnets across multiple AZs, plus internet and NAT gateways, routing tables, and tags.
* **Application tier** – Deploys an internet-facing Application Load Balancer, target group, HTTP/optional HTTPS listeners, IAM instance profile, launch template, and Auto Scaling Group of EC2 instances (Amazon Linux 2023) that serve a simple Nginx landing page via user data.
* **Data tier** – Provisions an Amazon RDS instance (PostgreSQL by default) in isolated subnets with security-group access restricted to the application tier. Encryption, automated backups, deletion protection, and multi-AZ are toggled through variables.

Each tier is encapsulated in its own Terraform module so you can reuse them independently or extend them for additional environments.

| Module | Description | Key resources |
| ------ | ----------- | ------------- |
| `modules/network` | Base networking fabric | `aws_vpc`, `aws_subnet`, `aws_nat_gateway`, routing |
| `modules/application` | Load balanced compute tier | `aws_lb`, `aws_autoscaling_group`, IAM roles, security groups |
| `modules/database` | Managed database tier | `aws_db_instance`, subnet group, security group |

## Prerequisites

1. Terraform v1.5+ installed and on your `PATH`.
2. AWS CLI (optional but recommended) for authenticating to your account.
3. AWS credentials available to Terraform via one of the supported mechanisms (environment variables, `~/.aws/credentials`, SSO session, etc.). Set `aws_profile` in `terraform.tfvars` if you rely on a named profile.
4. An S3 bucket and DynamoDB table for the remote backend defined in `versions.tf`. Update that file or supply `terraform init -backend-config=...` arguments so the backend points at your infrastructure before the first init.

## Usage

1. Clone this repository or copy the files into your own infrastructure repo.
2. Review `variables.tf` to understand all configurable inputs, including backend-related helpers.
3. Create a `terraform.tfvars` (start from `terraform.tfvars.example`) and customize the values for your environment, including sensitive items like `db_password`.
4. Update the `terraform { backend "s3" { ... } }` block in `versions.tf` (or pass `-backend-config` flags) so it references your S3 bucket/DynamoDB table before running init.
5. Initialize Terraform:

   ```bash
   terraform init
   # or, to override values without editing versions.tf:
   # terraform init -backend-config="bucket=my-bucket" -backend-config="key=my/key.tfstate" -backend-config="dynamodb_table=my-locks"
   ```

6. (Optional) Review execution plan:

   ```bash
   terraform plan
   ```

7. Apply the stack:

   ```bash
   terraform apply
   ```

8. After a successful apply, note the outputs for the ALB DNS name, ASG name, and (optionally) the database endpoint.

## Configuration Highlights

* **Networking** – Control CIDRs, AZ count, and even provide explicit subnet CIDRs. If unspecified, sensible CIDRs are auto-calculated from the VPC range.
* **Application tier** – Adjust instance type, Auto Scaling min/max/desired capacity, ALB ingress CIDRs, health check path, and whether to attach an HTTPS listener. Provide a custom user data script or rely on the baked-in Nginx sample plus optional extra shell commands.
* **Database tier** – Toggle the entire tier (`enable_database`), switch engines/versions, change storage sizes, enforce encryption, enable multi-AZ, and configure deletion protection. Set `db_skip_final_snapshot` to `false` in production to keep a backup on destroy.

All variables are documented in `variables.tf` and within each module. You can also compose the modules individually in your own root module if you need more control.

## Security and Operations Notes

* Ingress to the ALB defaults to `0.0.0.0/0`; restrict with `alb_ingress_cidrs`.
* Database access is locked to the application security group by default, keeping the DB private.
* IAM roles include SSM managed instance core, enabling Session Manager access without SSH keys.
* Consider remote backend storage (S3/DynamoDB) and CI/CD integration before using this in production.
* Review AWS service limits (Elastic IPs, NAT gateways, RDS instance types) for your target region.

## Cleanup

Destroy the environment when you are done to avoid ongoing costs:

```bash
terraform destroy
```

Always confirm there are no leftover stateful resources (RDS snapshots, EBS volumes, etc.) before concluding cleanup. If `db_skip_final_snapshot` is `false`, you must manually handle the retained snapshot.

## Terraform Docs (Root Module)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application"></a> [application](#module_application) | ./modules/application | n/a |
| <a name="module_database"></a> [database](#module_database) | ./modules/database | n/a |
| <a name="module_network"></a> [network](#module_network) | ./modules/network | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional_tags](#input_additional_tags) | Optional additional tags to apply to supported resources. | `map(string)` | `{}` | no |
| <a name="input_alb_ingress_cidrs"></a> [alb_ingress_cidrs](#input_alb_ingress_cidrs) | CIDR blocks allowed to reach the public load balancer. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_app_desired_capacity"></a> [app_desired_capacity](#input_app_desired_capacity) | Desired number of application instances. | `number` | `2` | no |
| <a name="input_app_health_check_path"></a> [app_health_check_path](#input_app_health_check_path) | Health check path for the target group. | `string` | `"/"` | no |
| <a name="input_app_instance_type"></a> [app_instance_type](#input_app_instance_type) | EC2 instance type for the application tier. | `string` | `"t3.micro"` | no |
| <a name="input_app_max_size"></a> [app_max_size](#input_app_max_size) | Maximum number of application instances in the ASG. | `number` | `4` | no |
| <a name="input_app_min_size"></a> [app_min_size](#input_app_min_size) | Minimum number of application instances in the ASG. | `number` | `1` | no |
| <a name="input_app_port"></a> [app_port](#input_app_port) | Port where the application listens inside the instance. | `number` | `80` | no |
| <a name="input_app_subnet_cidrs"></a> [app_subnet_cidrs](#input_app_subnet_cidrs) | Optional list of CIDR blocks for application subnets. Leave null to auto-calculate. | `list(string)` | `null` | no |
| <a name="input_app_user_data"></a> [app_user_data](#input_app_user_data) | Optional shell user data script for compute instances. Leave null to use the module default sample app. | `string` | `null` | no |
| <a name="input_aws_profile"></a> [aws_profile](#input_aws_profile) | Optional AWS CLI profile name to use for authentication. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws_region](#input_aws_region) | AWS region to deploy the stack into. | `string` | n/a | yes |
| <a name="input_az_count"></a> [az_count](#input_az_count) | Number of availability zones to span. | `number` | `2` | no |
| <a name="input_certificate_arn"></a> [certificate_arn](#input_certificate_arn) | ACM certificate ARN for the HTTPS listener. Required when enable_https_listener is true. | `string` | `null` | no |
| <a name="input_db_allocated_storage"></a> [db_allocated_storage](#input_db_allocated_storage) | Initial storage allocation for the database in GB. | `number` | `20` | no |
| <a name="input_db_apply_immediately"></a> [db_apply_immediately](#input_db_apply_immediately) | Apply database changes immediately instead of waiting for the next maintenance window. | `bool` | `true` | no |
| <a name="input_db_backup_retention"></a> [db_backup_retention](#input_db_backup_retention) | Backup retention period in days. | `number` | `7` | no |
| <a name="input_db_deletion_protection"></a> [db_deletion_protection](#input_db_deletion_protection) | Protect the database from accidental deletion. | `bool` | `false` | no |
| <a name="input_db_engine"></a> [db_engine](#input_db_engine) | Database engine (postgres, mysql, etc.). | `string` | `"postgres"` | no |
| <a name="input_db_engine_version"></a> [db_engine_version](#input_db_engine_version) | Database engine version. | `string` | `"15.3"` | no |
| <a name="input_db_instance_class"></a> [db_instance_class](#input_db_instance_class) | Instance class for the RDS instance. | `string` | `"db.t3.micro"` | no |
| <a name="input_db_max_allocated_storage"></a> [db_max_allocated_storage](#input_db_max_allocated_storage) | Maximum storage autoscaling size for the database in GB. | `number` | `100` | no |
| <a name="input_db_multi_az"></a> [db_multi_az](#input_db_multi_az) | Enable multi-AZ deployment for RDS. | `bool` | `false` | no |
| <a name="input_db_password"></a> [db_password](#input_db_password) | Master password for the database. | `string` | n/a | yes |
| <a name="input_db_port"></a> [db_port](#input_db_port) | Port for the database listener. Defaults to standard engine port. | `number` | `5432` | no |
| <a name="input_db_publicly_accessible"></a> [db_publicly_accessible](#input_db_publicly_accessible) | Whether the DB instance has a public endpoint. Keep false for production. | `bool` | `false` | no |
| <a name="input_db_skip_final_snapshot"></a> [db_skip_final_snapshot](#input_db_skip_final_snapshot) | Skip final snapshot on destroy. Disable to retain a backup. | `bool` | `true` | no |
| <a name="input_db_storage_encrypted"></a> [db_storage_encrypted](#input_db_storage_encrypted) | Enable storage encryption for the DB instance. | `bool` | `true` | no |
| <a name="input_db_subnet_cidrs"></a> [db_subnet_cidrs](#input_db_subnet_cidrs) | Optional list of CIDR blocks for database subnets. Leave null to auto-calculate. | `list(string)` | `null` | no |
| <a name="input_db_username"></a> [db_username](#input_db_username) | Master username for the database. | `string` | `"appuser"` | no |
| <a name="input_enable_database"></a> [enable_database](#input_enable_database) | Set to false to skip provisioning the database tier. | `bool` | `true` | no |
| <a name="input_enable_https_listener"></a> [enable_https_listener](#input_enable_https_listener) | Whether to create an HTTPS listener on the ALB. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input_environment) | Environment label (dev, staging, prod, etc.). | `string` | n/a | yes |
| <a name="input_extra_app_user_data"></a> [extra_app_user_data](#input_extra_app_user_data) | Additional shell commands appended to the default user data script. | `string` | `""` | no |
| <a name="input_project_name"></a> [project_name](#input_project_name) | Short name for the project used in tags and resource names. | `string` | n/a | yes |
| <a name="input_public_subnet_cidrs"></a> [public_subnet_cidrs](#input_public_subnet_cidrs) | Optional list of CIDR blocks for public subnets. Leave null to auto-calculate. | `list(string)` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr) | CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb_dns_name](#output_alb_dns_name) | DNS name of the application load balancer. |
| <a name="output_app_autoscaling_group_name"></a> [app_autoscaling_group_name](#output_app_autoscaling_group_name) | Name of the application Auto Scaling Group. |
| <a name="output_database_endpoint"></a> [database_endpoint](#output_database_endpoint) | Writer endpoint of the database (if created). |
| <a name="output_public_subnet_ids"></a> [public_subnet_ids](#output_public_subnet_ids) | IDs of the public subnets. |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | ID of the provisioned VPC. |
<!-- END_TF_DOCS -->
