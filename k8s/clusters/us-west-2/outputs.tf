output "mdn_apps_a_cluster_name" {
  value = module.mdn-apps-a.cluster_id
}

output "mdn_apps_a_cluster_endpoint" {
  value = module.mdn-apps-a.cluster_endpoint
}

output "mdn_apps_a_worker_iam_role_arn" {
  value = module.mdn-apps-a.worker_iam_role_arn
}

output "mdn_apps_a_worker_security_group_id" {
  value = module.mdn-apps-a.worker_security_group_id
}

output "mdn_apps_a_primary_security_group_id" {
  value = module.mdn-apps-a.cluster_primary_security_group_id
}

output "mdn_apps_a_cluster_oidc_issuer_url" {
  value = module.mdn-apps-a.cluster_oidc_issuer_url
}

output "mdn_cluster_name" {
  value = module.mdn.cluster_id
}

output "mdn_cluster_endpoint" {
  value = module.mdn.cluster_endpoint
}

output "mdn_cluster_primary_security_group_id" {
  value = module.mdn.cluster_primary_security_group_id
}

output "mdn_worker_security_group_id" {
  value = module.mdn.worker_security_group_id
}

output "mdn_cluster_oidc_issuer_url" {
  value = module.mdn.cluster_oidc_issuer_url
}

