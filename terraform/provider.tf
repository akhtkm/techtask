terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "techtask"

    workspaces {
      name = "github-actions"
    }
  }
}

provider "aws" {
  region = var.region
}
