resource "aws_route53_record" "main" {
  zone_id = var.domain-zone-id
  name    = var.domain-name
  type    = "CNAME"
  ttl     = var.domain-ttl
  records = [var.domain-name-alias]
}

