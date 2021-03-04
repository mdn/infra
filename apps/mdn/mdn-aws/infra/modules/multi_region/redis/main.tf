provider "aws" {
  region = var.region
}

locals {
  tags = {
    "Service"     = "MDN"
    "Region"      = var.region
    "Environment" = var.environment
    "Terraform"   = "true"
  }
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

resource "aws_elasticache_subnet_group" "mdn-redis-subnet-group" {
  count      = var.enabled ? 1 : 0
  name       = "${var.redis_name}-subnet-group"
  subnet_ids = data.aws_subnet_ids.this.ids
}

resource "aws_elasticache_replication_group" "mdn-redis-rg" {
  count                         = var.enabled ? 1 : 0
  automatic_failover_enabled    = var.redis_automatic_failover
  availability_zones            = var.azs
  multi_az_enabled              = true
  replication_group_id          = var.redis_name
  replication_group_description = "MDN Redis ${var.environment} cluster"
  node_type                     = var.redis_node_size
  number_cache_clusters         = var.redis_num_nodes
  port                          = var.redis_port
  parameter_group_name          = var.redis_param_group
  engine_version                = var.redis_engine_version
  subnet_group_name             = aws_elasticache_subnet_group.mdn-redis-subnet-group[0].name
  security_group_ids            = concat(var.nodes_security_group, list(aws_security_group.redis_sg.id))
  tags                          = merge({ "Name" = var.redis_name }, local.tags)
}


resource "aws_security_group" "redis_sg" {
  name        = "${var.redis_name}-redis-sg"
  description = "Allow inbound redis connection"
  vpc_id      = data.aws_vpc.id.id
  tags        = merge({ "Name" = "${var.redis_name}-redis-sg" }, local.tags)
}

resource "aws_security_group_rule" "redis_ingress" {
  type      = "ingress"
  from_port = var.redis_port
  to_port   = var.redis_port
  protocol  = "tcp"
  cidr_blocks = [
    data.aws_vpc.id.cidr_block
  ]
  security_group_id = aws_security_group.redis_sg.id
}

resource "aws_security_group_rule" "all_egress" {
  type      = "egress"
  to_port   = 0
  from_port = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.redis_sg.id
}
