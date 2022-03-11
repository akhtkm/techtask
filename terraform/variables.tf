variable "region" {
  description = "AWS Deployment region.."
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "The Deployment environment"
  default     = "development"
}

variable "system_name" {
  description = "The system name to deploy"
  default     = "wordpress"
}
