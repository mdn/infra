output "media_bucket_id" {
  value = element(concat(aws_s3_bucket.attachments.*.id, [""]), 0)
}

output "media_bucket_domain_name" {
  value = element(concat(aws_s3_bucket.attachments.*.bucket_domain_name, [""]), 0)
}

output "logging_bucket_id" {
  value = element(concat(aws_s3_bucket.logging.*.id, [""]), 0)
}

output "logging_bucket_domain_name" {
  value = element(concat(aws_s3_bucket.logging.*.bucket_domain_name, [""]), 0)
}
