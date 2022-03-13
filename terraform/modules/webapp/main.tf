locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

resource "random_string" "dns_suffix" {
  length = 6
  lower  = true
}

resource "aws_elastic_beanstalk_application" "wordpress" {
  name = "${local.name_suffix}-beanstalk"
  appversion_lifecycle {
    delete_source_from_s3 = true
    max_age_in_days       = 0
    max_count             = 200
    service_role          = "arn:aws:iam::470926947163:role/aws-elasticbeanstalk-service-role"
  }
  tags = {
    Environment = var.environment
  }
}

resource "aws_elastic_beanstalk_environment" "wordpress_env" {
  name                = "${local.name_suffix}-beanstalk-env"
  application         = aws_elastic_beanstalk_application.wordpress.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.11 running PHP 8.0"
  cname_prefix        = "${var.system_name}-${random_string.dns_suffix.result}"
  tier                = "WebServer"
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  tags = {
    Environment = var.environment
  }
}
