output "cdn_id" {
  value = "${element(concat(aws_cloudfront_distribution.this.*.id, list("")), 0)}"
}

output "cdn_domain_name" {
  value = "${element(concat(aws_cloudfront_distribution.this.*.domain_name, list("")),0)}"
}

output "cdn_iam_policy" {
  value = "${element(concat(aws_iam_policy.cdn-invalidate.*.arn, list("")), 0)}"
}
