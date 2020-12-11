output "site_bucket" {
  value = aws_s3_bucket.site-bucket.id
}

output "site_bucket_domain_name" {
  value = aws_s3_bucket.site-bucket.bucket_domain_name
}

output "logging_site_bucket" {
  value = aws_s3_bucket.site-bucket-logs.id
}

output "logging_site_bucket_domain_name" {
  value = aws_s3_bucket.site-bucket-logs.bucket_domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.site-distribution.id
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.site-distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.site-distribution.hosted_zone_id
}
