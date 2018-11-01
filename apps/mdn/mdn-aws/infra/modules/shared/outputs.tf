output efs_backup_bucket_name {
  value = "${element(concat(aws_s3_bucket.mdn-shared-backup.*.id, list("")),0 )}"
}

output efs_backup_user_access_key {
  value = "${element(concat(aws_iam_access_key.mdn-efs-backup-user.*.id, list("")), 0)}"
}

output efs_backup_user_secret_key {
  value = "${element(concat(aws_iam_access_key.mdn-efs-backup-user.*.secret, list("")), 0)}"
}

output downloads_bucket_name {
  value = "${element(concat(aws_s3_bucket.mdn-downloads.*.id, list("")), 0)}"
}

output downloads_bucket_website_endpoint {
  value = "${element(concat(aws_s3_bucket.mdn-downloads.*.website_endpoint, list("")), 0)}"
}
