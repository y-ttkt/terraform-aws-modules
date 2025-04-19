terraform {
  required_version = "1.10.5"
  backend "s3" {
    bucket = "training-terraform-tfstate"
    key    = "terraform.tfstate"
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
  region = local.region
  default_tags {
    tags = local.default_tags
  }
}

// エイリアス付きプロバイダ
provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
  default_tags {
    tags = local.default_tags
  }
}
