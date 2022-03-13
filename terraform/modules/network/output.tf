output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}
