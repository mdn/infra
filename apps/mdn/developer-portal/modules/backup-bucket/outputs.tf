output "bucket_id" {
  value = element(concat(aws_s3_bucket.this.*.id, [""]), 0)
}

output "bucket_iam_role_name" {
  value = element(concat(aws_iam_role.this.*.name, [""]), 0)
}

output "bucket_iam_role_arn" {
  value = element(concat(aws_iam_role.this.*.arn, [""]), 0)
}

output "bucket_iam_user_access_key" {
  value = element(concat(aws_iam_access_key.this.*.id, [""]), 0)
}

output "bucket_iam_user_secret_key" {
  value = element(concat(aws_iam_access_key.this.*.secret, [""]), 0)
}

