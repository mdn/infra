output "redis_endpoint" {
  value = element(
    concat(
      aws_elasticache_replication_group.mdn-redis-rg.*.primary_endpoint_address,
      [""],
    ),
    0,
  )
}

