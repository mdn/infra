output "vpc_id" {
  value = "${local.vpc_id}"
}

output "public_subnets" {
  value = ["${data.aws_subnet_ids.public_subnets.ids}"]
}

output "private_subnets" {
  value = "${module.subnets-eu-central-1.private_subnets}"
}
