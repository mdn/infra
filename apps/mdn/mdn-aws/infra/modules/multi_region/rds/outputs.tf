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

output "rds_security_group_id" {
  value = element(concat(aws_security_group.mdn_rds_sg.*.id, [""]), 0)
}

output "rds_subnet_group_name" {
  value = element(concat(aws_db_subnet_group.rds.*.name, [""]), 0)
}
