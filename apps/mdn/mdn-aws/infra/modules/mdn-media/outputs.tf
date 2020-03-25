output "bucket_name" {
  value = aws_s3_bucket.media.id
}

output "bucket_website_endpoint" {
  value = aws_s3_bucket.media.website_endpoint
}

output "bucket_logging_name" {
  value = aws_s3_bucket.logging.id
}

output "bucket_iam_policy" {
  value = aws_iam_policy.bucket-policy.arn
}

