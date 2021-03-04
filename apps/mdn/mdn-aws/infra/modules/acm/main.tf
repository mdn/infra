data "aws_region" "current" {
}

# Just using DNS validation for now
resource "aws_acm_certificate" "cert" {
  domain_name = var.domain_name

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name      = var.domain_name
    Region    = data.aws_region.current.name
    Service   = "MDN ACM certificate"
    Terraform = "true"
  }
}

resource "aws_route53_record" "cert_validation_dns" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = var.zone_id
  ttl             = 60
}

# This functions as a waiter, so if validation happens via
# email we don't care we create the cert and move on
resource "aws_acm_certificate_validation" "cert_dns" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_dns : record.fqdn]
}

