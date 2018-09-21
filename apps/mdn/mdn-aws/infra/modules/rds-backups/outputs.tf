
output "backup-bucket-users" {
  value = "${aws_iam_access_key.backup-user-key.id}"
}

output "backup-bucket-key" {
  value = "${aws_iam_access_key.backup-user-key.secret}"
}
