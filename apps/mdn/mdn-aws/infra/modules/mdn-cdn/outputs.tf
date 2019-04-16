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
