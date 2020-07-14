output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_groups" {
  value = module.eks.node_groups
}

output "workers_asg_names" {
  value = module.eks.workers_asg_names
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

