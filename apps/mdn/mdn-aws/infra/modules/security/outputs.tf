output "worf_role_name" {
  value = module.iam_assumable_role_admin.this_iam_role_name
}

output "worf_role_arn" {
  value = module.iam_assumable_role_admin.this_iam_role_arn
}
