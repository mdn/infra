output "rds-backup-bucket-name" {
  value = aws_s3_bucket.backup-bucket.id
}

output "rds_backup_role_arn" {
  value = module.iam_assumable_role_admin.this_iam_role_arn
}

output "rds_backup_role_name" {
  value = module.iam_assumable_role_admin.this_iam_role_name
}
