# resource "aws_elastic_beanstalk_application" "wordpress" {
#   name = "wordpress"

#   appversion_lifecycle {
#     delete_source_from_s3 = true
#     max_age_in_days       = 0
#     max_count             = 200

#   }
# }

# resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
#   name                = "beanstalk_env"
#   application         = aws_elastic_beanstalk_application.wordpress
#   solution_stack_name = "64bit Amazon Linux 2 v3.3.11 running PHP 8.0"
#   tier                = "WebServer"
# }