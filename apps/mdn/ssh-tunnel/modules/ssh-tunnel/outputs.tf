
output "tunnel_server_ip" {
  value = aws_eip.ssh-tunnel.public_ip
}

output "tunnel_fqdn" {
  value = aws_route53_record.ssh-tunnel.fqdn
}
