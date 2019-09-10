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

output "mdn_apps_a_cluster_name" {
  value = "${module.mdn-apps-a.cluster_id}"
}

output "mdn_apps_a_cluster_endpoint" {
  value = "${module.mdn-apps-a.cluster_endpoint}"
}

output "mdn_apps_a_worker_asg_names" {
  value = "${module.mdn-apps-a.worker_asg_names}"
}

output "mdn_apps_a_worker_iam_role_arn" {
  value = "${module.mdn-apps-a.worker_iam_role_arn}"
}

output "mdn_apps_a_worker_security_group_id" {
  value = "${module.mdn-apps-a.worker_security_group_id}"
}
