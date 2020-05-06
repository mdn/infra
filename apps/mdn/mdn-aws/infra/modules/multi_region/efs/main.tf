provider "aws" {
  region = var.region
}

locals {
  enabled = var.enabled ? 1 : 0

  tags = {
    Service     = "MDN"
    Environment = var.environment
    Region      = var.region
    Terraform   = "true"
  }
}

# FIXME: I did not do a subnet discovery because terraform deletes
# and then creates the mount targets over again. So its easier to just
# leave it be for now.
data "aws_vpc" "id" {
  id = var.vpc_id
}

resource "aws_efs_file_system" "mdn-shared-efs" {
  count            = local.enabled
  performance_mode = var.performance_mode
  tags             = merge({ "Name" = "mdn-shared-${var.efs_name}" }, local.tags)
}

resource "aws_efs_mount_target" "mdn-shared-mt" {
  count           = local.enabled * length(var.subnets)
  file_system_id  = aws_efs_file_system.mdn-shared-efs[0].id
  subnet_id       = element(var.subnets, count.index)
  security_groups = concat(var.nodes_security_group, list(aws_security_group.efs_sg.id))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.efs_name}-efs-sg"
  description = "Allow inbound efs connection"
  vpc_id      = data.aws_vpc.id.id
  tags        = merge({ "Name" = "${var.efs_name}-efs-sg" }, local.tags)
}

resource "aws_security_group_rule" "efs_ingress" {
  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"
  cidr_blocks = [
    data.aws_vpc.id.cidr_block
  ]
  security_group_id = aws_security_group.efs_sg.id
}

resource "aws_security_group_rule" "all_egress" {
  type      = "egress"
  to_port   = 0
  from_port = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.efs_sg.id
}
