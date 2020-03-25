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
  security_group_ids            = var.security_groups

  tags = {
    Name      = local.instance_name
    Region    = var.region
    Terraform = "true"
  }
}

