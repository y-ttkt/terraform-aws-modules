locals {
  project = "Training"
  region  = "ap-northeast-1"
  default_tags = {
    Managed     = "terraform"
    Project     = local.project
    Environment = local.env
  }
  github_repository_prefix = local.project
}
