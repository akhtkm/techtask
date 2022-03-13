locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    "Tier" = "Private"
  }
}

resource "aws_rds_cluster" "rds" {
  backtrack_window                = 0
  backup_retention_period         = 1
  copy_tags_to_snapshot           = true
  database_name                   = "ebdb"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql5_6.name
  availability_zones              = var.azs
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  deletion_protection             = false
  engine                          = "aurora"
  kms_key_id                      = "arn:aws:kms:ap-northeast-1:470926947163:key/dea847c1-ed25-4062-91f7-33b4f45707cb"
  master_username                 = "admin"
  master_password                 = random_password.password.result
  port                            = 3306
  preferred_backup_window         = "17:10-17:40"
  preferred_maintenance_window    = "sun:19:03-sun:19:33"
  storage_encrypted               = true
  vpc_security_group_ids          = [var.db_security_group_id]

  tags = {
    Name        = "${local.name_suffix}-database"
    Environment = var.environment
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql5_6" {
  family = "aurora-mysql5.6"
  name   = "${local.name_suffix}-pg-aurora-mysql5-6"
  tags = {
    Name        = "${local.name_suffix}-pg-aurora-mysql5-6"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "rds" {
  subnet_ids = data.aws_subnets.private.ids
  tags = {
    Name        = "${local.name_suffix}-sg"
    Environment = var.environment
  }
}
