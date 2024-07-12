terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "vpn"
      Name        = "vpn-manager"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
