provider "aws" {
  region = var.region
}

data "aws_vpc" "id" {
  id = var.vpc_id
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:SubnetType"
    values = [var.subnet_type]
  }
}

locals {
  tags = {
    Service     = "MDN"
    Environment = var.environment
    Region      = var.region
    Terraform   = "true"
  }
}

resource "aws_db_subnet_group" "rds" {
  count       = (var.enabled ? 1 : 0) * (length(var.rds_subnet_group_name) > 0 ? 0 : 1)
  name        = "mdn-${var.environment}-rds-subnet-group"
  description = "mdn-${var.environment}-rds-subnet-group"
  subnet_ids  = data.aws_subnet_ids.this.ids
  tags        = merge({ "Name" = "mdn-${var.environment}-rds-subnet-group" }, local.tags)
}

data "aws_iam_role" "rds_monitor_role" {
  name = "rds-monitoring-role"
}

resource "aws_db_instance" "mdn_postgres" {
  count = var.enabled ? 1 : 0

  allocated_storage           = var.postgres_storage_gb
  allow_major_version_upgrade = var.postgres_allow_major_version_upgrade
  auto_minor_version_upgrade  = var.postgres_auto_minor_version_upgrade
  backup_retention_period     = var.postgres_backup_retention_days
  backup_window               = var.postgres_backup_window

  db_subnet_group_name = length(var.rds_subnet_group_name) > 0 ? var.rds_subnet_group_name : element(aws_db_subnet_group.rds.*.name, count.index)

  depends_on = [aws_security_group.mdn_rds_sg]
  engine     = var.postgres_engine

  iops                = (var.environment == "prod" && length(var.rds_subnet_group_name) == 0)  ? 1000 : null
  deletion_protection = var.environment == "prod" ? true : false

  engine_version               = var.postgres_engine_version
  identifier                   = var.postgres_identifier #"mdn-prod-postgres"
  instance_class               = var.postgres_instance_class
  maintenance_window           = var.postgres_maintenance_window
  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = data.aws_iam_role.rds_monitor_role.arn
  multi_az                     = true
  name                         = var.postgres_db_name #"developer_mozilla_org"
  parameter_group_name         = "default.postgres13" # need to create this state as well
  password                     = var.postgres_password
  publicly_accessible          = false
  storage_encrypted            = var.postgres_storage_encrypted
  storage_type                 = var.postgres_storage_type
  username                     = var.postgres_username
  performance_insights_enabled = true
  skip_final_snapshot          = false
  port                         = var.postgres_port
  vpc_security_group_ids       = [length(var.rds_security_group_id) > 0 ? var.rds_security_group_id : aws_security_group.mdn_rds_sg[0].id]
  final_snapshot_identifier    = "mdn-${var.environment}-postgres-final"
  tags                         = merge({ "Name" = "MDN-${var.environment}-postgres" }, local.tags)
}

resource "aws_security_group" "mdn_rds_sg" {
  count       = (var.enabled ? 1 : 0) * (length(var.rds_security_group_id) > 0 ? 0 : 1)
  name        = var.rds_security_group_name
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.postgres_port
    to_port     = var.postgres_port
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.id.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ "Name" = "mdn_rds_sg-${var.environment}" }, local.tags)
}

