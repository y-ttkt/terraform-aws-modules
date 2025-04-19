locals {
  project = "training"
  region  = "ap-northeast-1"
  default_tags = {
    Managed     = "terraform"
    Project     = "Training"
    Environment = local.env
  }
  github_repository_prefix = local.project
}
