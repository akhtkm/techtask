locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

resource "aws_rds_cluster" "rds" {
  backtrack_window                = 0
  backup_retention_period         = 1
  copy_tags_to_snapshot           = true
  database_name                   = "ebdb"
  db_cluster_parameter_group_name = aws_db_parameter_group.aurora_mysql5_7.tags.Name
  availability_zones              = var.azs
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  deletion_protection             = false
  engine                          = "aurora"
  kms_key_id                      = "arn:aws:kms:ap-northeast-1:470926947163:key/dea847c1-ed25-4062-91f7-33b4f45707cb"
  master_username                 = "admin"
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

resource "aws_db_parameter_group" "aurora_mysql5_7" {
  family = "aurora-mysql5.7"
  tags = {
    Name        = "${local.name_suffix}-pg-aurora-mysql5_7"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "rds" {
  subnet_ids = var.private_subnet_ids
  tags = {
    Name        = "${local.name_suffix}-sg"
    Environment = var.environment
  }
}
