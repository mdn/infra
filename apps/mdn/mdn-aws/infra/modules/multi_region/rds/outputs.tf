output "rds_arn" {
  value = element(concat(aws_db_instance.mdn_rds.*.arn, [""]), 0)
}

output "rds_address" {
  value = element(concat(aws_db_instance.mdn_rds.*.address, [""]), 0)
}

output "rds_endpoint" {
  value = element(concat(aws_db_instance.mdn_rds.*.endpoint, [""]), 0)
}

output "rds_id" {
  value = element(concat(aws_db_instance.mdn_rds.*.id, [""]), 0)
}

