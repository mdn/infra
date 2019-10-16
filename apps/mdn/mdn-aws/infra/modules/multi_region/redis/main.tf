provider "aws" {
  region = "${var.region}"
}

resource "aws_elasticache_subnet_group" "mdn-redis-subnet-group" {
  count = "${var.enabled}"
  name  = "redis-${var.redis_name}-subnet-group"

  # https://github.com/hashicorp/terraform/issues/57#issuecomment-100372002
  subnet_ids = ["${split(",", var.subnets)}"]
}

resource "aws_elasticache_replication_group" "mdn-redis-rg" {
  count                         = "${var.enabled}"
  replication_group_id          = "mdn-redis-${var.redis_name}"
  replication_group_description = "MDN Redis ${var.redis_name} cluster"
  node_type                     = "${var.redis_node_size}"
  number_cache_clusters         = "${var.redis_num_nodes}"
  port                          = "${var.redis_port}"
  parameter_group_name          = "${var.redis_param_group}"
  engine_version                = "${var.redis_engine_version}"
  subnet_group_name             = "${aws_elasticache_subnet_group.mdn-redis-subnet-group.name}"
  security_group_ids            = ["${var.nodes_security_group}"]

  tags {
    Name        = "MDN-${var.redis_name}-${var.environment}"
    Stack       = "MDN-${var.redis_name}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
    Terraform   = "true"
  }
}
