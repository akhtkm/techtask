locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

resource "aws_security_group" "alb" {
  description = "allow http(s) connection to wordpress slb"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  name = "${local.name_suffix}-slb-sg"
  tags = {
    Name        = "${local.name_suffix}-alb-sg"
    Environment = var.environment
  }
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  prefix_list_ids   = [var.allow_access_pl]
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  prefix_list_ids   = [var.allow_access_pl]
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
}

resource "aws_alb" "wordpress" {
  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = false
  enable_deletion_protection = false
  enable_http2               = true
  enable_waf_fail_open       = false
  idle_timeout               = 60
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "${var.system_name}-alb"
  security_groups = [
    aws_security_group.alb.id
  ]
  subnets = var.public_subnets.*.id
  tags = {
    Name        = "${local.name_suffix}-alb"
    Environment = var.environment
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.wordpress.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.wordpress.arn
    type             = "forward"
  }

}
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.wordpress.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-northeast-1:470926947163:certificate/4d151787-f7f7-4b06-a9ae-751f3a74552c"
  default_action {
    target_group_arn = aws_alb_target_group.wordpress.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "wordpress" {
  deregistration_delay          = "300"
  load_balancing_algorithm_type = "round_robin"
  name                          = "target-wordpress-ec2-http"
  port                          = 80
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = 0
  tags                          = {}
  tags_all                      = {}
  target_type                   = "instance"
  vpc_id                        = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

resource "aws_alb_target_group_attachment" "wordpress_1" {
  target_group_arn = aws_alb_target_group.wordpress.arn
  target_id        = var.wordpress_ec2_id_1
  port             = 80
}

resource "aws_alb_target_group_attachment" "wordpress_2" {
  target_group_arn = aws_alb_target_group.wordpress.arn
  target_id        = var.wordpress_ec2_id_2
  port             = 80
}