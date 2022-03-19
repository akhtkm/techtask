locals {
  environment = "development"
  region      = "ap-northeast-1"
  system_name = "wordpress"
  azs         = ["${var.region}a", "${var.region}c"]
  allow_cidrs = ["133.32.128.250/32", "113.43.73.18/32"]
}

module "iam" {
  source  = "./modules/iam"
  pgp_key = "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"
}

module "dns" {
  source      = "./modules/dns"
  domain_name = "training2.yumemi.io"
  # bs_cname     = module.webapp.cname
  # bs_zone      = module.webapp.zone
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
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
  allow_cidrs     = local.allow_cidrs
}

module "ec2" {
  source          = "./modules/ec2"
  environment     = local.environment
  region          = local.region
  system_name     = local.system_name
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  alb_sg_id       = module.alb.alb_sg_id
  allow_access_pl = module.network.allow_access_pl
  azs             = local.azs
}

# module "webapp" {
#   source                = "./modules/webapp"
#   environment           = local.environment
#   region                = local.region
#   system_name           = local.system_name
#   vpc_id                = module.network.vpc_id
#   allow_cidrs           = local.allow_cidrs
#   rds_endpoint          = module.database.rds_endpoint
#   rds_password          = module.database.rds_password
#   rds_security_group    = module.database.rds_security_group
#   bs_rds_endpoint       = module.database.bs_rds_endpoint
#   bs_rds_password       = module.database.bs_rds_password
#   bs_rds_security_group = module.database.bs_rds_security_group

# }

module "database" {
  source      = "./modules/database"
  environment = local.environment
  region      = local.region
  system_name = local.system_name
  azs         = local.azs
  vpc_id      = module.network.vpc_id
  allow_cidrs = local.allow_cidrs
}

module "alb" {
  source             = "./modules/alb"
  environment        = local.environment
  region             = local.region
  system_name        = local.system_name
  vpc_id             = module.network.vpc_id
  public_subnets     = module.network.public_subnets
  allow_access_pl    = module.network.allow_access_pl
  wordpress_ec2_id_1 = module.ec2.wordpress_ec2_id_1
  wordpress_ec2_id_2 = module.ec2.wordpress_ec2_id_2
}
