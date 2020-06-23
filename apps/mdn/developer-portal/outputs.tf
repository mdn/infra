output "db_stage_hostname" {
  value = module.db_stage.hostname
}

output "bucket_dev_name" {
  value = module.bucket_dev.bucket_id
}

output "db_dev_hostname" {
  value = module.db_dev.hostname
}

output "bucket_stage_name" {
  value = module.bucket_stage.bucket_id
}

output "bucket_stage_website_endpoint" {
  value = module.bucket_stage.bucket_website_endpoint
}

output "bucket_stage_role_arn" {
  value = module.bucket_stage.bucket_iam_role_arn
}

output "bucket_stage_iam_user_access_key" {
  value = module.bucket_stage.bucket_iam_user_access_key
}

output "bucket_stage_iam_user_secret_key" {
  value = module.bucket_stage.bucket_iam_user_secret_key
}

output "mail_stage_smtp_host" {
  value = module.mail_stage.smtp_host
}

output "mail_stage_user" {
  value = module.mail_stage.smtp_user
}

output "mail_stage_secret" {
  value = module.mail_stage.secret
}

output "mail_stage_password" {
  value = module.mail_stage.smtp_password
}

output "redis_stage_endpoint" {
  value = module.redis_stage.redis_endpoint
}

output "db_prod_hostname" {
  value = module.db_prod.hostname
}

output "bucket_prod_name" {
  value = module.bucket_prod.bucket_id
}

output "bucket_prod_website_endpoint" {
  value = module.bucket_prod.bucket_website_endpoint
}

output "bucket_prod_role_arn" {
  value = module.bucket_prod.bucket_iam_role_arn
}

output "bucket_prod_iam_user_access_key" {
  value = module.bucket_prod.bucket_iam_user_access_key
}

output "bucket_prod_iam_user_secret_key" {
  value = module.bucket_prod.bucket_iam_user_secret_key
}

output "redis_prod_endpoint" {
  value = module.redis_prod.redis_endpoint
}

output "backup_bucket_iam_role_arn" {
  value = module.backup_bucket.bucket_iam_role_arn
}
