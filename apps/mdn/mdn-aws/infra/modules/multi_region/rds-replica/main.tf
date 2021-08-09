provider "aws" {
  region = var.region
}

locals {
  name_prefix          = "${var.replica_identifier}-${var.environment}-replica"
  postgres_name_prefix = "${var.replica_identifier}-${var.environment}-postgres-replica"
  tags = {
    Service     = "MDN"
    Environment = var.environment
    Region      = var.region
    Terraform   = "true"
  }
}

data "aws_vpc" "vpc_cidr" {
  id = var.vpc_id
}

data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:SubnetType"
    values = [var.subnet_type]
  }
}

resource "aws_db_subnet_group" "replica" {
  name        = "${local.name_prefix}-subnet-group"
  description = "${local.name_prefix}-subnet-group"
  subnet_ids  = data.aws_subnet_ids.this.ids
  tags        = merge({ "Name" = "${local.name_prefix}-subnet-group" }, local.tags)
}

resource "aws_db_instance" "replica" {
  count = var.enabled ? 1 : 0

  identifier           = local.name_prefix
  replicate_source_db  = var.replica_source_db
  instance_class       = var.instance_class
  storage_type         = var.storage_type
  kms_key_id           = var.kms_key_id
  storage_encrypted    = true
  db_subnet_group_name = aws_db_subnet_group.replica.name

  vpc_security_group_ids = [aws_security_group.replica-sg[0].id]
  multi_az               = var.multi_az

  apply_immediately   = true
  skip_final_snapshot = true
  monitoring_interval = var.monitoring_interval
  tags                = merge({ "Name" = local.name_prefix }, local.tags)
}

resource "aws_db_instance" "postgres_replica" {
  count = var.enabled ? 1 : 0


  iops                 = var.environment == "prod" ? 1000 : null
  identifier           = local.postgres_name_prefix #"mdn-prod-postgres-replica"
  replicate_source_db  = var.postgres_replica_source_db
  instance_class       = var.postgres_instance_class
  storage_type         = "io1"
  storage_encrypted    = true
  db_subnet_group_name = aws_db_subnet_group.replica.name

  vpc_security_group_ids = [aws_security_group.replica-sg[0].id]
  multi_az               = var.multi_az

  apply_immediately   = true
  skip_final_snapshot = true
  monitoring_interval = var.monitoring_interval
  tags                = merge({ "Name" = local.postgres_name_prefix }, local.tags)
}

resource "aws_security_group" "replica-sg" {
  count = var.enabled ? 1 : 0
  name  = "${local.name_prefix}-sg"

  vpc_id = var.vpc_id

  ingress {
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.vpc_cidr.cidr_block]
  }

  ingress {
    from_port   = var.postgres_port
    to_port     = var.postgres_port
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.vpc_cidr.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" = "${local.name_prefix}-sg" }, local.tags)
}

