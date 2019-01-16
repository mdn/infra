output "rds_arn" {
  value = "${element(concat(aws_db_instance.mdn_rds.*.arn, list("")), 0)}"
}

output "rds_address" {
  value = "${element(concat(aws_db_instance.mdn_rds.*.address, list("")), 0)}"
}

output "rds_endpoint" {
  value = "${element(concat(aws_db_instance.mdn_rds.*.endpoint, list("")), 0)}"
}

output "rds_id" {
  value = "${element(concat(aws_db_instance.mdn_rds.*.id, list("")), 0)}"
}
