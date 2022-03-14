variable "region" {
  description = "AWS Deployment region.."
}

variable "environment" {
  description = "The Deployment environment"
}

variable "system_name" {
  description = "The system name to deploy"
}

variable "vpc_id" {}
variable "allow_cidrs" {
  type = list(any)
}
variable "rds_endpoint" {}
variable "rds_password" {}
variable "rds_security_group" {}
