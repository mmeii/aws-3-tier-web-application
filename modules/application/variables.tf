variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "alb_ingress_cidrs" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "app_port" {
  type = number
}

variable "health_check_path" {
  type = string
}

variable "user_data" {
  type    = string
  default = null
}

variable "additional_user_data" {
  type    = string
  default = ""
}

variable "enable_https_listener" {
  type    = bool
  default = false
}

variable "certificate_arn" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
