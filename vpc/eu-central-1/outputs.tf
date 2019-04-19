output "vpc_id" {
  value = "${module.vpc-eu-central-1.vpc_id}"
}

output "public_subnets" {
  value = "${module.subnets-eu-central-1.public_subnets}"
}

output "private_subnets" {
  value = "${module.subnets-eu-central-1.private_subnets}"
}
