output "bucket_id" {
  value = element(concat(aws_s3_bucket.this.*.id, [""]), 0)
}

output "bucket_website_endpoint" {
  value = element(concat(aws_s3_bucket.this.*.website_endpoint, [""]), 0)
}

output "bucket_domain_name" {
  value = element(concat(aws_s3_bucket.this.*.bucket_domain_name, [""]), 0)
}

output "bucket_hosted_zone_id" {
  value = element(concat(aws_s3_bucket.this.*.hosted_zone_id, [""]), 0)
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

output "media_bucket_id" {
  value = element(concat(aws_s3_bucket.attachments.*.id, [""]), 0)
}

output "media_bucket_domain_name" {
  value = element(
    concat(aws_s3_bucket.attachments.*.bucket_domain_name, [""]),
    0,
  )
}

output "logging_bucket_id" {
  value = element(concat(aws_s3_bucket.logging.*.id, [""]), 0)
}

output "logging_bucket_domain_name" {
  value = element(concat(aws_s3_bucket.logging.*.bucket_domain_name, [""]), 0)
}

