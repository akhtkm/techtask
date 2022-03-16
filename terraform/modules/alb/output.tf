output "alb_zone_id" {
  value = aws_alb.wordpress.zone_id
}

output "alb_dns_name" {
  value = aws_alb.wordpress.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}