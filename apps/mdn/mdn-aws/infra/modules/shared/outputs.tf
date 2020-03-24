output "efs_backup_bucket_name" {
  value = element(concat(aws_s3_bucket.mdn-shared-backup.*.id, [""]), 0)
}

output "efs_backup_user_access_key" {
  value = element(concat(aws_iam_access_key.mdn-efs-backup-user.*.id, [""]), 0)
}

output "efs_backup_user_secret_key" {
  value = element(
    concat(aws_iam_access_key.mdn-efs-backup-user.*.secret, [""]),
    0,
  )
}

output "downloads_bucket_name" {
  value = element(concat(aws_s3_bucket.mdn-downloads.*.id, [""]), 0)
}

output "downloads_bucket_website_endpoint" {
  value = element(
    concat(aws_s3_bucket.mdn-downloads.*.website_endpoint, [""]),
    0,
  )
}

