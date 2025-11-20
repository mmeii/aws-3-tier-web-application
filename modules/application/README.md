# Application Module

Creates the compute tier: security groups, Application Load Balancer (HTTP/optional HTTPS), launch template, IAM role/profile, and Auto Scaling Group running Amazon Linux 2023 instances. Ships with a simple Nginx splash page and exposes hooks for custom user data.

## Usage

```hcl
module "application" {
  source              = "./modules/application"
  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  app_subnet_ids      = module.network.app_subnet_ids
  alb_ingress_cidrs   = ["10.0.0.0/16"]
  instance_type       = "t3.micro"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  app_port            = 80
  health_check_path   = "/"
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
| [aws_autoscaling_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.al2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_user_data"></a> [additional_user_data](#input_additional_user_data) | n/a | `string` | `""` | no |
| <a name="input_alb_ingress_cidrs"></a> [alb_ingress_cidrs](#input_alb_ingress_cidrs) | n/a | `list(string)` | n/a | yes |
| <a name="input_app_port"></a> [app_port](#input_app_port) | n/a | `number` | n/a | yes |
| <a name="input_app_subnet_ids"></a> [app_subnet_ids](#input_app_subnet_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate_arn](#input_certificate_arn) | n/a | `string` | `null` | no |
| <a name="input_desired_capacity"></a> [desired_capacity](#input_desired_capacity) | n/a | `number` | n/a | yes |
| <a name="input_enable_https_listener"></a> [enable_https_listener](#input_enable_https_listener) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input_environment) | n/a | `string` | n/a | yes |
| <a name="input_health_check_path"></a> [health_check_path](#input_health_check_path) | n/a | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type) | n/a | `string` | n/a | yes |
| <a name="input_max_size"></a> [max_size](#input_max_size) | n/a | `number` | n/a | yes |
| <a name="input_min_size"></a> [min_size](#input_min_size) | n/a | `number` | n/a | yes |
| <a name="input_project_name"></a> [project_name](#input_project_name) | n/a | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public_subnet_ids](#input_public_subnet_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user_data](#input_user_data) | n/a | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb_dns_name](#output_alb_dns_name) | n/a |
| <a name="output_alb_security_group_id"></a> [alb_security_group_id](#output_alb_security_group_id) | n/a |
| <a name="output_app_security_group_id"></a> [app_security_group_id](#output_app_security_group_id) | n/a |
| <a name="output_asg_name"></a> [asg_name](#output_asg_name) | n/a |
<!-- END_TF_DOCS -->
