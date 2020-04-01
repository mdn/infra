
resource "aws_route53_record" "ssh-tunnel" {
  zone_id = data.terraform_remote_state.dns.outputs.us-west-2-zone-id
  name    = "tunnel"
  type    = "A"
  ttl     = "300"
  records = [
    aws_eip.ssh-tunnel.public_ip
  ]
}
