locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

resource "aws_instance" "wordpress_1" {
  ami                    = "ami-04204a8960917fd92"
  availability_zone      = "ap-northeast-1a"
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.wordpress_ec2_sg.id]
  tags = {
    Name        = "${local.name_suffix}-ec2-1"
    Environment = var.environment
  }
}

resource "aws_instance" "wordpress_2" {
  ami                         = "ami-053ac2a39367f8eeb"
  associate_public_ip_address = true
  availability_zone           = "ap-northeast-1c"
  instance_type               = "t3.medium"
  key_name                    = "wordpress-ap-northeast-1"
  subnet_id                   = "subnet-0b882d4b8408d7838"
  vpc_security_group_ids      = [aws_security_group.wordpress_ec2_sg.id]
  tags = {
    Name        = "${local.name_suffix}-ec2-2"
    Environment = var.environment
  }
}

# resource "aws_instance" "dummy1" {
#   count                       = length(var.azs)
#   ami                         = "ami-053ac2a39367f8eeb"
#   associate_public_ip_address = true
#   availability_zone           = element(var.azs, count.index)
#   instance_type               = "t3.medium"
#   key_name                    = "${var.system_name}-${var.region}"
#   subnet_id                   = element(var.public_subnets.*.id, count.index)
#   vpc_security_group_ids      = [aws_security_group.wordpress_ec2_sg.id]
#   tags = {
#     Name        = "${local.name_suffix}-ec2-dummy-${count.index}"
#     Environment = var.environment
#   }
# }

resource "aws_security_group" "wordpress_ec2_sg" {
  description = "sg for wordpress ec2 instance"
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  name = "${local.name_suffix}-ec2-sg"
  tags = {
    Name        = "${local.name_suffix}-ec2-sg"
    Environment = var.environment
  }
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.wordpress_ec2_sg.id
  prefix_list_ids   = [var.allow_access_pl]
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "allow_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.wordpress_ec2_sg.id
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = var.alb_sg_id
  to_port                  = 80
}

