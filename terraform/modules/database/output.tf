output "rds_endpoint" {
  value = aws_rds_cluster.rds.endpoint
}

output "rds_password" {
  value     = random_password.password.result
  sensitive = true
}

output "rds_security_group" {
  value = aws_security_group.db.id
}