
resource "aws_route53_record" "ssh-tunnel" {
  zone_id = var.zone_id
  name    = "tunnel"
  type    = "A"
  ttl     = "300"
  records = [
    aws_eip.ssh-tunnel.public_ip
  ]
}
