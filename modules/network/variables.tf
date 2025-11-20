variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type    = number
  default = 2
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = null
}

variable "app_subnet_cidrs" {
  type    = list(string)
  default = null
}

variable "db_subnet_cidrs" {
  type    = list(string)
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
