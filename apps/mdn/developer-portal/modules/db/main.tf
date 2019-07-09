locals {
  identifier = "${var.identifier}-${var.environment}"
}

data "aws_vpc" "this" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "this" {
  vpc_id = "${data.aws_vpc.this.id}"

  filter {
    name   = "tag:SubnetType"
    values = ["Private"]
  }
}

resource "aws_db_subnet_group" "this" {
  name        = "${local.identifier}-rds-subnet-group"
  description = "${local.identifier}-rds-subnet-group"
  subnet_ids  = ["${data.aws_subnet_ids.this.ids}"]
}

resource "aws_db_instance" "this" {
  engine                 = "postgres"
  engine_version         = "${var.engine_version}"
  allocated_storage      = "${var.db_storage}"
  instance_class         = "${var.instance_class}"
  storage_type           = "${var.db_storage_type}"
  storage_encrypted      = "${var.storage_encrypted}"
  identifier             = "${local.identifier}"
  name                   = "${var.db_name}"
  username               = "${var.db_user}"
  password               = "${var.db_password}"
  multi_az               = "${var.multi_az}"
  db_subnet_group_name   = "${aws_db_subnet_group.this.id}"
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  publicly_accessible    = false
  skip_final_snapshot    = true
  apply_immediately      = true
  monitoring_interval    = "${var.monitoring_interval}"

  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.allow_minor_version_upgrade}"
  backup_retention_period     = "${var.backup_retention_days}"
  backup_window               = "${var.backup_window}"
  maintenance_window          = "${var.maintenance_window}"

  tags {
    Name        = "${local.identifier}"
    Environment = "${var.environment}"
    Project     = "developer-portal"
    Terraform   = "true"
  }
}

resource "aws_security_group" "this" {
  name        = "${local.identifier}-sg"
  description = "Allow inbound traffic into DB"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name      = "${local.identifier}-sg"
    Region    = "${var.region}"
    Project   = "developer-portal"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "allow_in" {
  type              = "ingress"
  security_group_id = "${aws_security_group.this.id}"
  from_port         = "${var.db_port}"
  to_port           = "${var.db_port}"
  cidr_blocks       = ["${data.aws_vpc.this.cidr_block}"]
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_out" {
  type              = "egress"
  security_group_id = "${aws_security_group.this.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
