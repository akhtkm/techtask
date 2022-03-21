locals {
  environment = "development"
  region      = "ap-northeast-1"
  system_name = "wordpress"
  azs         = ["${var.region}a", "${var.region}c"]
  allow_cidrs = ["133.32.128.250/32", "113.43.73.18/32"]
}

module "iam" {
  source = "./modules/iam"
}

module "dns" {
  source      = "./modules/dns"
  domain_name = "training2.yumemi.io"
  # bs_cname     = module.webapp.cname
  # bs_zone      = module.webapp.zone
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "cloudfront" {
  source = "./modules/cloudfront"
  region = "us-east-1"
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
