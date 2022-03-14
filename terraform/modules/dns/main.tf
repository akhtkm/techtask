data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "beanstalk" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "web.${var.domain_name}"
  type    = "A"
  alias {
    name                   = var.cname
    zone_id                = var.zone
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "ec2" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = "wordpress-alb-1526874562.ap-northeast-1.elb.amazonaws.com"
    zone_id                = "Z14GRHDCWA56QT"
    evaluate_target_health = true
  }
}
