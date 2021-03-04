output "cdn-primary-logging-bucket" {
  value = element(concat(aws_s3_bucket.logging.*.id, [""]), 0)
}

