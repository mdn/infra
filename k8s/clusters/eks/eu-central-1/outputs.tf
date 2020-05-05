output "mdn_cluster_name" {
  value = module.mdn.cluster_id
}

output "mdn_cluster_endpoint" {
  value = module.mdn.cluster_endpoint
}

output "mdn_cluster_primary_security_group_id" {
  value = module.mdn.cluster_primary_security_group_id
}

output "mdn_cluster_iam_role_arn" {
  value = module.mdn.cluster_iam_role_arn
}

output "mdn_node_groups" {
  value = module.mdn.node_groups
}

output "mdn_cluster_oidc_issuer_url" {
  value = module.mdn.cluster_oidc_issuer_url
}

