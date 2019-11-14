output "cdn-attachments-dns" {
  value = "${module.cloudfront-attachments.cdn-attachments-dns}"
}

output "cdn-primary-dns" {
  value = "${module.primary-cloudfront.cdn-primary-dns}"
}

output "cdn-primary-logging-bucket" {
  value = "${module.primary-cloudfront.cdn-primary-logging-bucket}"
}

output "cdn-attachments-logging-bucket" {
  value = "${module.cloudfront-attachments.cdn-attachments-logging-bucket}"
}

output "cdn-media-dns" {
  value = "${module.media-cdn.cdn_domain_name}"
}

output "cdn-media-iam-policy" {
  value = "${module.media-cdn.cdn_iam_policy}"
}
