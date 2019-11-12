output "cluster_name" {
  value = "k8s.us-west-2.mdn.mozit.cloud"
}

output "master_security_group_ids" {
  value = ["${module.kubernetes.master_security_group_ids}"]
}

output "node_security_group_ids" {
  value = ["${module.kubernetes.node_security_group_ids}"]
}

output "nodes_role_arn" {
  value = "${module.kubernetes.nodes_role_arn}"
}

output "node_subnet_ids" {
  value = ["${module.kubernetes.node_subnet_ids}"]
}

output "vpc_id" {
  value = "${module.kubernetes.vpc_id}"
}

output "ark_bucket" {
  value = "${module.ark_bucket.bucket_name}"
}

output "ark_access_key" {
  value = "${module.ark_bucket.backup_user_access_key}"
}

output "ark_secret_key" {
  value = "${module.ark_bucket.backup_user_secret_key}"
}
