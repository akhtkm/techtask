locals {
  environment = "development"
  region      = "ap-northeast-1"
  system_name = "wordpress"
  azs         = ["${var.region}a", "${var.region}c"]
}

module "network" {
  source          = "./modules/network"
  environment     = local.environment
  region          = local.region
  system_name     = local.system_name
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
  azs             = local.azs
}

module "webapp" {
  source      = "./modules/webapp"
  environment = local.environment
  region      = local.region
  system_name = local.system_name
  vpc_id      = module.network.vpc_id
}

module "database" {
  source               = "./modules/database"
  environment          = local.environment
  region               = local.region
  system_name          = local.system_name
  azs                  = local.azs
  private_subnet_ids   = module.network.private_subnet_ids
  db_security_group_id = module.network.db_security_group_id
}
