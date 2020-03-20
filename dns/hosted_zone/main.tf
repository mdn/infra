resource "aws_route53_zone" "region-zone" {
  name = "${var.zone_name}.${var.domain_name}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name      = "${var.zone_name}.${var.domain_name}"
    Purpose   = "${var.zone_name} stub zone"
    Terraform = "true"
  }
}

resource "aws_route53_record" "region-hosted-record" {
  zone_id = var.zone_id
  name    = var.zone_name

  type = "NS"
  ttl  = "86400"

  records = aws_route53_zone.region-zone.name_servers
}

