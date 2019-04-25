output "cluster_name" {
  value = "${module.sandbox-eks.cluster_id}"
}

output "cluster_endpoint" {
  value = "${module.sandbox-eks.cluster_endpoint}"
}
