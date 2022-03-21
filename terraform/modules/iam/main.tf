# resource "aws_iam_role" "aws-elasticbeanstalk-service-role" {
#   assume_role_policy = <<POLICY
# {
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Condition": {
#         "StringEquals": {
#           "sts:ExternalId": "elasticbeanstalk"
#         }
#       },
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "elasticbeanstalk.amazonaws.com"
#       }
#     }
#   ],
#   "Version": "2012-10-17"
# }
# POLICY

#   managed_policy_arns  = ["arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy", "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"]
#   max_session_duration = "3600"
#   name                 = "aws-elasticbeanstalk-service-role"
#   path                 = "/"
# }


# resource "aws_iam_policy" "beanstalk_service" {
#   name   = "beanstalk_service"
#   policy = <<-EOT
#     {
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Effect": "Allow",
#                 "Action": [
#                     "elasticloadbalancing:DescribeInstanceHealth",
#                     "elasticloadbalancing:DescribeLoadBalancers",
#                     "elasticloadbalancing:DescribeTargetHealth",
#                     "ec2:DescribeInstances",
#                     "ec2:DescribeInstanceStatus",
#                     "ec2:GetConsoleOutput",
#                     "ec2:AssociateAddress",
#                     "ec2:DescribeAddresses",
#                     "ec2:DescribeSecurityGroups",
#                     "sqs:GetQueueAttributes",
#                     "sqs:GetQueueUrl",
#                     "autoscaling:DescribeAutoScalingGroups",
#                     "autoscaling:DescribeAutoScalingInstances",
#                     "autoscaling:DescribeScalingActivities",
#                     "autoscaling:DescribeNotificationConfigurations",
#                     "sns:Publish"
#                 ],
#                 "Resource": [
#                     "*"
#                 ]
#             }
#         ]
#     }
#   EOT
# }

resource "aws_iam_user" "wordpress_plugin" {
  name = "AWSForWordPressPlugin"
}

data "aws_iam_policy" "wordpress_plugin" {
  arn = "arn:aws:iam::aws:policy/AWSForWordPressPluginPolicy"
}

resource "aws_iam_user_policy_attachment" "wordpress_plugin" {
  user       = aws_iam_user.wordpress_plugin.name
  policy_arn = data.aws_iam_policy.wordpress_plugin.arn
}

# resource "aws_iam_access_key" "wordpress_plugin" {
#   user    = aws_iam_user.wordpress_plugin.name
#   pgp_key = var.pgp_key
# }