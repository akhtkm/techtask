locals {
  name_suffix = "${var.system_name}-${var.environment}"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${local.name_suffix}-vpc"
    Environment = var.environment
  }
}

# Public Subnet

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${local.name_suffix}-${element(var.azs, count.index)}-public-subnet"
    Environment = var.environment
  }
}

# Internet Gateway for the public subnet

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${local.name_suffix}-igw"
    Environment = var.environment
  }
}

# Elastic IP for internet gateway

resource "aws_eip" "public" {
  vpc = true
  depends_on = [
    aws_internet_gateway.public
  ]
}

# NAT Gateway

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.public.id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  depends_on = [
    aws_internet_gateway.public
  ]

  tags = {
    Name        = "${var.environment}-ngw"
    Environment = var.environment
  }
}

# Private Subnet

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${local.name_suffix}-${element(var.azs, count.index)}-private-subnet"
    Environment = var.environment
  }
}

# Route table for private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${local.name_suffix}-private-route-table"
    Environment = var.environment
  }
}

# Route table for public subnet

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${local.name_suffix}-public-route-table"
    Environment = var.environment
  }
}

# Route for internet gateway

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

# Route for NAT gateway

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.private.id
}

# Route table association

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
