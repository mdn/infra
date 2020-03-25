output "efs_backup_bucket" {
  value = module.mdn_shared.efs_backup_bucket_name
}

output "efs_backup_user_access_key" {
  value = module.mdn_shared.efs_backup_user_access_key
}

output "efs_backup_user_secret_key" {
  value = module.mdn_shared.efs_backup_user_secret_key
}

output "primary_cdn_domain" {
  value = module.mdn_cdn.cdn-primary-dns
}

output "attachment_cdn_domain" {
  value = module.mdn_cdn_prod.cdn-attachments-dns
}

output "downloads_bucket_name" {
  value = module.mdn_shared.downloads_bucket_name
}

output "downloads_bucket_website" {
  value = module.mdn_shared.downloads_bucket_website_endpoint
}

output "us-west-2-efs-dns" {
  value = module.efs-us-west-2.efs_dns
}

output "us-west-2-redis-stage-endpoint" {
  value = module.redis-stage-us-west-2.redis_endpoint
}

output "us-west-2-rds-endpoint" {
  value = module.mysql-us-west-2.rds_endpoint
}

output "ci_acm_arn" {
  value = module.acm_ci.certificate_arn
}

output "rds_backup_bucket" {
  value = module.rds-backups.rds-backup-bucket-name
}

output "rds_backup_user" {
  value = module.rds-backups.rds-backup-bucket-users
}

output "rds_backup_secret_key" {
  value = module.rds-backups.rds-backup-bucket-key
}

output "worf_user" {
  value = module.security.worf_user
}

output "work_user_secret_key" {
  value = module.security.worf_secret_key
}

