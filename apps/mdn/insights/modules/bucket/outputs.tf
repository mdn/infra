output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

output "logging_bucket_id" {
  value = aws_s3_bucket.logging.id
}

output "logging_bucket_domain_name" {
  value = aws_s3_bucket.logging.bucket_domain_name
}

output "logging_bucket_regional_domain_name" {
  value = aws_s3_bucket.logging.bucket_regional_domain_name
}
