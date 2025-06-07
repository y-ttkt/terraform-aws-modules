resource "aws_iam_role" "app_ec2_role" {
  name = "${local.project}-${local.env}-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# EC2 インスタンスはロールを直接アタッチできず、内部的にはインスタンスプロファイル経由でロールを渡している
resource "aws_iam_instance_profile" "app_ec2_profile" {
  name = "${local.project}-${local.env}-ec2-profile"
  role = aws_iam_role.app_ec2_role.name
}

data "aws_iam_policy_document" "app_s3_access" {
  statement {
    sid = "AllowAppEC2S3Access"
    actions = [
      "s3:ListBucket",        # バケット一覧取得
      "s3:GetBucketLocation", # バケットのリージョン取得
      "s3:GetObject",         # オブジェクト取得
      "s3:PutObject",         # オブジェクトアップロード
      "s3:DeleteObject",      # オブジェクト削除
      "s3:PutObjectAcl",      # オブジェクトACL設定
    ]
    resources = [
      # バケット自体への ListBucket（リスト）許可
      aws_s3_bucket.uploads.arn,
      # オブジェクト操作用
      "${aws_s3_bucket.uploads.arn}/*",
    ]
  }
}

# 任意で aws_iam_policy を切り出す場合
resource "aws_iam_policy" "app_s3_policy" {
  name        = "${local.project}-${local.env}-s3-policy"
  description = "Allow EC2 app to access uploads bucket"
  policy      = data.aws_iam_policy_document.app_s3_access.json
}
