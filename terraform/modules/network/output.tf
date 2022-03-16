output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "allow_access_pl" {
  value = aws_ec2_managed_prefix_list.allow_access_pl.id
}
