locals {
  instance_name = "${var.redis_id}-${var.environment}"
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${local.instance_name}-sg"
  subnet_ids = var.subnets
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  automatic_failover_enabled    = true
  replication_group_id          = local.instance_name
  replication_group_description = "Developer Portal ${var.environment} redis cluster"
  engine                        = "redis"
  engine_version                = var.redis_engine
  port                          = var.redis_port
  node_type                     = var.redis_node_type
  parameter_group_name          = var.redis_param_group
  number_cache_clusters         = var.redis_nodes
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = concat(var.security_groups, list(aws_security_group.redis_sg.id))

  tags = {
    Name      = local.instance_name
    Region    = var.region
    Terraform = "true"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "${local.instance_name}-redis-sg"
  description = "Allow inbound redis connection"
  vpc_id      = data.aws_vpc.id.id

  tags = {
    Name        = "${local.instance_name}-redis-sg"
    Region      = var.region
    Environment = var.environment
    Service     = "developer-portal"
    Terraform   = true
  }
}

resource "aws_security_group_rule" "redis_ingress" {
  type      = "ingress"
  from_port = 6379
  to_port   = 6379
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
