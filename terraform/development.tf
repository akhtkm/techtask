locals {
  environment = "development"
  region      = "ap-northeast-1"
  system_name = "wordpress"
  azs         = ["${var.region}a", "${var.region}c"]
  allow_cidrs = ["133.32.128.250/32", "113.43.73.18/32"]

}

module "dns" {
  source      = "./modules/dns"
  domain_name = "training2.yumemi.io"
  cname       = module.webapp.cname
  zone        = module.webapp.zone
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
  source             = "./modules/webapp"
  environment        = local.environment
  region             = local.region
  system_name        = local.system_name
  vpc_id             = module.network.vpc_id
  allow_cidrs        = local.allow_cidrs
  rds_endpoint       = module.database.rds_endpoint
  rds_password       = module.database.rds_password
  rds_security_group = module.database.rds_security_group
}

module "database" {
  source      = "./modules/database"
  environment = local.environment
  region      = local.region
  system_name = local.system_name
  azs         = local.azs
  vpc_id      = module.network.vpc_id
  allow_cidrs = local.allow_cidrs
}
