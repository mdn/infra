output "bucket_id" {
  value = "${element(concat(aws_s3_bucket.this.*.id, list("")),0)}"
}

output "bucket_iam_role_name" {
  value = "${element(concat(aws_iam_role.this.*.name, list("")),0)}"
}

output "bucket_iam_role_arn" {
  value = "${element(concat(aws_iam_role.this.*.arn, list("")),0)}"
}

output "bucket_iam_user_access_key" {
  value = "${element(concat(aws_iam_access_key.this.*.id, list("")),0)}"
}

output "bucket_iam_user_secret_key" {
  value = "${element(concat(aws_iam_access_key.this.*.secret, list("")),0)}"
}
