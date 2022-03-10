terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_vpc" "ex-terraform" {
    cidr_block = "10.0.0.0/16"
}