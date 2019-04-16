output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "nat_gateway_ids" {
  value = ["${aws_nat_gateway.nat_gw.*.id}"]
}
