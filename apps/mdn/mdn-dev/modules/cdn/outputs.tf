output "site_bucket" {
  value = "${aws_s3_bucket.site-bucket.id}"
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.site-distribution.id}"
}

output "cloudfront_domain" {
  value = "${aws_cloudfront_distribution.site-distribution.domain_name}"
}

output "cloudfront_hosted_zone_id" {
  value = "${aws_cloudfront_distribution.site-distribution.hosted_zone_id}"
}
