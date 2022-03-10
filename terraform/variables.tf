variable "region" {
  description = "AWS Deployment region.."
  default     = "ap-northeast-1"

}

variable "environment" {
  description = "The Deployment environment"
  default     = "development"

}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  default     = "10.0.0.0/16"

}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
  default     = ["10.0.1.0/24"]

}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
  default     = ["10.0.10.0/24"]
}
