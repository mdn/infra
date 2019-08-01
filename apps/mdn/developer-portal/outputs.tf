output "db_stage_hostname" {
  value = "${module.db_stage.hostname}"
}

output "bucket_stage_name" {
  value = "${module.bucket_stage.bucket_id}"
}

output "bucket_stage_website_endpoint" {
  value = "${module.bucket_stage.bucket_website_endpoint}"
}

output "bucket_stage_role_arn" {
  value = "${module.bucket_stage.bucket_iam_role_arn}"
}

output "bucket_iam_user_access_key" {
  value = "${module.bucket_stage.bucket_iam_user_access_key}"
}

output "bucket_iam_user_secret_key" {
  value = "${module.bucket_stage.bucket_iam_user_secret_key}"
}
