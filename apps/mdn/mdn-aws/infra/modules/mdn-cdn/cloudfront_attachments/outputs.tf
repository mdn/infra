output "cdn-attachments-arn" {
  value = element(
    concat(
      aws_cloudfront_distribution.mdn-attachments-cf-dist.*.arn,
      [""],
    ),
    0,
  )
}

output "cdn-attachments-dns" {
  value = element(
    concat(
      aws_cloudfront_distribution.mdn-attachments-cf-dist.*.domain_name,
      [""],
    ),
    0,
  )
}

output "cdn-attachments-logging-bucket" {
  value = element(concat(aws_s3_bucket.logging.*.id, [""]), 0)
}

