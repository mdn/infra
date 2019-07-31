output "cluster_id" {
  value = "${module.eks.cluster_id}"
}

output "cluster_endpoint" {
  value = "${module.eks.cluster_endpoint}"
}

output "cluster_arn" {
  value = "${module.eks.cluster_arn}"
}

output "worker_asg_names" {
  value = "${module.eks.workers_asg_names}"
}

output "worker_iam_role_arn" {
  value = "${module.eks.worker_iam_role_arn}"
}

output "worker_security_group_id" {
  value = "${module.eks.worker_security_group_id}"
}
