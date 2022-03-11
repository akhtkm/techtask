variable "region" {
  description = "AWS Deployment region.."
}

variable "environment" {
  description = "The Deployment environment"
}

variable "system_name" {
  description = "The system name to deploy"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

variable "azs" {
  type        = list(any)
  description = "Ths availability zone for subnet"
}
