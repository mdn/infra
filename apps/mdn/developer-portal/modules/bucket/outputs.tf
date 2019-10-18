output "bucket_id" {
  value = "${element(concat(aws_s3_bucket.this.*.id, list("")),0)}"
}

output "bucket_website_endpoint" {
  value = "${element(concat(aws_s3_bucket.this.*.website_endpoint, list("")),0)}"
}

output "bucket_domain_name" {
  value = "${element(concat(aws_s3_bucket.this.*.bucket_domain_name, list("")),0)}"
}

output "bucket_hosted_zone_id" {
  value = "${element(concat(aws_s3_bucket.this.*.hosted_zone_id, list("")),0)}"
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

output "media_bucket_id" {
  value = "${element(concat(aws_s3_bucket.attachments.*.id, list("")),0)}"
}

output "media_bucket_domain_name" {
  value = "${element(concat(aws_s3_bucket.attachments.*.bucket_domain_name, list("")),0)}"
}
