output "efs_dns" {
  value = "${module.efs.efs_dns}"
}

output "redis_endpoint" {
  value = "${module.redis.redis_endpoint}"
}

output "rds_address" {
  value = "${module.mysql.rds_address}"
}

output "rds_endpoint" {
  value = "${module.mysql.rds_endpoint}"
}
