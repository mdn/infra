output "delegation_sets" {
  value = "${join(",", aws_route53_delegation_set.delegation-set.name_servers)}"
}

output "delegation_set_id" {
  value = "${aws_route53_delegation_set.delegation-set.id}"
}

output "master-zone" {
  value = "${element(concat(aws_route53_zone.master-zone.*.zone_id, list("")), 0)}"
}

output "mdn-dev-zone" {
  value = "${element(concat(aws_route53_zone.mdn-dev.*.zone_id, list("")), 0)}"
}

output "us-west-2-zone-id" {
  value = "${module.us-west-2.hosted_zone_id}"
}

output "us-west-2a-zone-id" {
  value = "${module.us-west-2a.hosted_zone_id}"
}

output "eu-central-1-zone-id" {
  value = "${module.eu-central-1.hosted_zone_id}"
}

output "dev-zone-id" {
  value = "${module.dev.hosted_zone_id}"
}

output "stage-zone-id" {
  value = "${module.stage.hosted_zone_id}"
}

output "prod-zone-id" {
  value = "${module.prod.hosted_zone_id}"
}
