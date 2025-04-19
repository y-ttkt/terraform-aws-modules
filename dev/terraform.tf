terraform {
  required_version = "1.10.5"
  backend "s3" {
    bucket = "training-terraform-tfstate"
    key    = "develop.terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.44.0"
    }
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = local.default_tags
  }
}
