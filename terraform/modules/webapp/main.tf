locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

resource "random_string" "dns_suffix" {
  length = 6
  lower  = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    "Tier" = "Public"
  }
}


data "aws_elastic_beanstalk_hosted_zone" "current" {}

data "aws_elastic_beanstalk_solution_stack" "php_latest" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running PHP 8.0$"
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
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.php_latest.name
  cname_prefix        = "${var.system_name}-${random_string.dns_suffix.result}"
  tier                = "WebServer"
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.rds_security_group
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnets.public.ids)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "internet facing"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 2
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 4
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = "admin"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = var.rds_password
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = var.rds_endpoint
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_elastic_beanstalk_application_version" "wordpress-beanstalk" {
  application = aws_elastic_beanstalk_application.wordpress.name
  bucket      = "wordpress-beanstalk-daludh78"
  key         = "wordpress-beanstalk.zip"
  name        = "0.1"
}
