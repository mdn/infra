output "id" {
  value = aws_db_instance.this.id
}

output "database_security_group_id" {
  value = aws_security_group.this.id
}

output "hosted_zone_id" {
  value = aws_db_instance.this.hosted_zone_id
}

output "hostname" {
  value = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "endpoint" {
  value = aws_db_instance.this.endpoint
}

