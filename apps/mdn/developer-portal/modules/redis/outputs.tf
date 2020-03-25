output "redis_endpoint" {
  value = element(
    concat(
      aws_elasticache_replication_group.redis_cluster.*.primary_endpoint_address,
      [""],
    ),
    0,
  )
}

