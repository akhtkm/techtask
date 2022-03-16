output "rds_password" {
  value     = random_password.password.result
  sensitive = true
}
output "rds_endpoint" {
  value = aws_rds_cluster.rds.endpoint
}

output "rds_security_group" {
  value = aws_security_group.db.id
}

# output "bs_rds_password" {
#   value     = random_password.bs_password.result
#   sensitive = true
# }

# output "bs_rds_endpoint" {
#   value = aws_rds_cluster.bs_rds.endpoint
# }

# output "bs_rds_security_group" {
#   value = aws_security_group.bs_db.id
# }