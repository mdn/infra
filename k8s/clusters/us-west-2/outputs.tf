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

