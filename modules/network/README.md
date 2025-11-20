# Network Module

Provision the base networking layer (VPC, subnets, routing, and NAT/IGW) that underpins the three-tier architecture. Drop this module into any Terraform configuration where you need opinionated multi-tier networking with sane defaults and tagging.

## Usage

```hcl
module "network" {
  source     = "./modules/network"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  az_count     = 3
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
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_subnet_cidrs"></a> [app_subnet_cidrs](#input_app_subnet_cidrs) | n/a | `list(string)` | `null` | no |
| <a name="input_az_count"></a> [az_count](#input_az_count) | n/a | `number` | `2` | no |
| <a name="input_db_subnet_cidrs"></a> [db_subnet_cidrs](#input_db_subnet_cidrs) | n/a | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input_environment) | n/a | `string` | n/a | yes |
| <a name="input_project_name"></a> [project_name](#input_project_name) | n/a | `string` | n/a | yes |
| <a name="input_public_subnet_cidrs"></a> [public_subnet_cidrs](#input_public_subnet_cidrs) | n/a | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc_cidr](#input_vpc_cidr) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_subnet_ids"></a> [app_subnet_ids](#output_app_subnet_ids) | n/a |
| <a name="output_availability_zones"></a> [availability_zones](#output_availability_zones) | n/a |
| <a name="output_db_subnet_ids"></a> [db_subnet_ids](#output_db_subnet_ids) | n/a |
| <a name="output_public_subnet_ids"></a> [public_subnet_ids](#output_public_subnet_ids) | n/a |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id) | n/a |
<!-- END_TF_DOCS -->
