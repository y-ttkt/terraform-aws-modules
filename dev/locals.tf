locals {
  env = "dev"
  availability_zones = [
    "ap-northeast-1a",
    "ap-northeast-1c",
  ]
  az_suffix = {
    for az in local.availability_zones :
    az => substr(az, length(az) - 1, 1)
  }
  # 例: {
  #   "ap-northeast-1a" = "a"
  #   "ap-northeast-1c" = "c"
  # }
}
