output "cdn-arn" {
  value = "${element(concat(aws_cloudfront_distribution.mdn-wiki.*.arn, list("")), 0)}"
}
