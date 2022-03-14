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

resource "aws_security_group" "db" {
  vpc_id = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = var.allow_cidrs
    from_port   = "3306"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3306"
  }

  tags = {
    Name        = "${local.name_suffix}-sg-db"
    Environment = var.environment
  }
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier_prefix       = "${local.name_suffix}-database-"
  backtrack_window                = 0
  backup_retention_period         = 1
  copy_tags_to_snapshot           = true
  database_name                   = "ebdb"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_5_6.name
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
  vpc_security_group_ids          = [aws_security_group.db.id]

  tags = {
    Name        = "${local.name_suffix}-database"
    Environment = var.environment
  }
}

resource "aws_rds_cluster_instance" "rds_instances" {
  count              = 2
  identifier         = "rds-${count.index}"
  cluster_identifier = aws_rds_cluster.rds.id
  instance_class     = "db.r4.large"
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version
}

resource "aws_rds_cluster_parameter_group" "aurora_5_6" {
  family = "aurora5.6"
  name   = "${local.name_suffix}-pg-aurora-5-6"
  tags = {
    Name        = "${local.name_suffix}-pg-aurora-5-6"
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
