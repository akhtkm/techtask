# resource "aws_iam_role" "beanstalk_service" {
#     name= "beanstalk_service_role"
    
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
