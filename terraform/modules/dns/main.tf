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

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "_e31072ec1bfac1dfbafb14cd9039b9a6.web.training2.yumemi.io"
  type    = "CNAME"
  records = ["_8cf63b83a47fc52bbbac8ac5e898a1cc.jhztdrwbnw.acm-validations.aws"]
  ttl     = 300
}

resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "web.training2.yumemi.io"
  type    = "CNAME"
  records = ["d1yl8lo0p8uipl.cloudfront.net"]
  ttl     = 300
}