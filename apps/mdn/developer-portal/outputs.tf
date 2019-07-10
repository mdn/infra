output "db_stage_hostname" {
  value = "${module.db_stage.hostname}"
}

output "bucket_stage_name" {
  value = "${module.bucket_stage.bucket_id}"
}

output "bucket_stage_role_arn" {
  value = "${module.bucket_stage.bucket_iam_role_arn}"
}
