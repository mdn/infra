output "postgres_replica_rds_id" {
  value = element(concat(aws_db_instance.postgres_replica.*.id, [""]), 0)
}
