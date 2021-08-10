output "postgres_rds_arn" {
  value = element(concat(aws_db_instance.mdn_postgres.*.arn, [""]), 0)
}

output "postgres_rds_address" {
  value = element(concat(aws_db_instance.mdn_postgres.*.address, [""]), 0)
}

output "postgres_rds_endpoint" {
  value = element(concat(aws_db_instance.mdn_postgres.*.endpoint, [""]), 0)
}

output "postgres_rds_id" {
  value = element(concat(aws_db_instance.mdn_postgres.*.id, [""]), 0)
}
