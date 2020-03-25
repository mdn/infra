output "worf_user" {
  value = aws_iam_access_key.worf-keys.id
}

output "worf_secret_key" {
  value = aws_iam_access_key.worf-keys.secret
}

