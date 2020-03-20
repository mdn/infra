output "mdn_apps_a_cluster_name" {
  value = module.mdn-apps-a.cluster_id
}

output "mdn_apps_a_cluster_endpoint" {
  value = module.mdn-apps-a.cluster_endpoint
}

output "mdn_apps_a_workers_asg_names" {
  value = module.mdn-apps-a.workers_asg_names
}

output "mdn_apps_a_worker_iam_role_arn" {
  value = module.mdn-apps-a.worker_iam_role_arn
}

output "mdn_apps_a_worker_security_group_id" {
  value = module.mdn-apps-a.worker_security_group_id
}

