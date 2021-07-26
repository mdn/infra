output "ssh_security_group_id" {
  value = aws_security_group.ssh.id
}

output "ssh_security_group_arn" {
  value = aws_security_group.ssh.arn
}
