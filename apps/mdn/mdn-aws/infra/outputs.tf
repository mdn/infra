output "efs_backup_bucket" {
  value = module.mdn_shared.efs_backup_bucket_name
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

output "rds_backup_role_arn" {
  value = module.rds-backups.rds_backup_role_arn
}

output "media-sync-role_arn" {
  value = module.media-sync-roles.role_arn
}

output "worf_role_arn" {
  value = module.security.worf_role_arn
}

