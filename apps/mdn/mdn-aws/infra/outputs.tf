output "downloads_bucket_name" {
  value = module.mdn_shared.downloads_bucket_name
}

output "downloads_bucket_website" {
  value = module.mdn_shared.downloads_bucket_website_endpoint
}

output "us-west-2-redis-stage-endpoint" {
  value = module.redis-stage-us-west-2.redis_endpoint
}

output "us-west-2-postgres-rds-endpoint" {
  value = module.mysql-us-west-2.postgres_rds_endpoint
}

output "ci_acm_arn" {
  value = module.acm_ci.certificate_arn
}

output "rds_backup_bucket" {
  value = module.rds-backups.rds-backup-bucket-name
}

output "rds_backup_role_arn" {
  value = module.rds-backups.rds_backup_role_arn
}

output "media-sync-role_arn" {
  value = module.media-sync-roles.role_arn
}
