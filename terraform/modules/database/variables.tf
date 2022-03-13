variable "region" {
  description = "AWS Deployment region.."
}

variable "environment" {
  description = "The Deployment environment"
}

variable "system_name" {
  description = "The system name to deploy"
}

variable "azs" {
  type        = list(any)
  description = "Ths availability zone for subnet"
}

variable "vpc_id" {}
variable "db_security_group_id" {}
