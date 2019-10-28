output "rds-backup-bucket-users" {
  value = "${aws_iam_access_key.backup-user-key.id}"
}

output "rds-backup-bucket-key" {
  value = "${aws_iam_access_key.backup-user-key.secret}"
}

output "rds-backup-bucket-name" {
  value = "${aws_s3_bucket.backup-bucket.id}"
}
