locals {
  azs = ["${var.region}a", "${var.region}b"]
}

module "network" {
  source          = "./modules/network/"
  environment     = "development"
  region          = "ap-northeast-1"
  system_name     = "wordpress"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
  azs             = local.azs
}
