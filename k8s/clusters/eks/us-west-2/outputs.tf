output "developer_portal_cluster_name" {
  value = "${module.k8s-developer-portal.cluster_id}"
}

output "developer_portal_cluster_endpoint" {
  value = "${module.k8s-developer-portal.cluster_endpoint}"
}

output "developer_portal_worker_asg_names" {
  value = "${module.k8s-developer-portal.worker_asg_names}"
}

output "developer_portal_worker_iam_role_arn" {
  value = "${module.k8s-developer-portal.worker_iam_role_arn}"
}

output "developer_portal_worker_security_group_id" {
  value = "${module.k8s-developer-portal.worker_security_group_id}"
}
