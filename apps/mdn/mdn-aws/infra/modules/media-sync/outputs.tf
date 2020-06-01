output "role_arn" {
  value = module.iam_assumable_role.this_iam_role_arn
}

output "role_name" {
  value = module.iam_assumable_role.this_iam_role_name
}
