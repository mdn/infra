output "smtp_user" {
  value = aws_iam_access_key.email.id
}

output "smtp_password" {
  value = aws_iam_access_key.email.ses_smtp_password
}

output "secret" {
  value = aws_iam_access_key.email.secret
}

output "smtp_host" {
  value = "email-smtp.${var.region}.amazonaws.com"
}
