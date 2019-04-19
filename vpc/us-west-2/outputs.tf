output "vpc_id" {
  value = "${module.vpc-us-west-2.vpc_id}"
}

output "public_subnets" {
  value = "${module.subnets-us-west-2.public_subnets}"
}

output "private_subnets" {
  value = "${module.subnets-us-west-2.private_subnets}"
}
