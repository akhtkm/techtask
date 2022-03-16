data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}

# resource "aws_route53_record" "beanstalk" {
#   zone_id = data.aws_route53_zone.public.zone_id
#   name    = "web.${var.domain_name}"
#   type    = "A"
#   alias {
#     name                   = var.bs_cname
#     zone_id                = var.bs_zone
#     evaluate_target_health = false
#   }
# }

resource "aws_route53_record" "ec2" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
