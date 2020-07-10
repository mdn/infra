output "db_stage_hostname" {
  value = module.db_stage.hostname
}

output "db_dev_hostname" {
  value = module.db_dev.hostname
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

output "redis_prod_endpoint" {
  value = module.redis_prod.redis_endpoint
}

output "backup_bucket_iam_role_arn" {
  value = module.backup_bucket.bucket_iam_role_arn
}
