resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.app.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.app.key_name
  associate_public_ip_address = false
  disable_api_stop            = false
  disable_api_termination     = false
  monitoring                  = false
  subnet_id                   = aws_subnet.public[index(local.availability_zones, "ap-northeast-1a")].id

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = "8"
  }

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  tags = {
    Name = "${local.project}-${local.env}-ec2-webapp"
  }
}

resource "aws_eip" "app" {
  instance = aws_instance.app.id
  domain   = "vpc"

  tags = {
    Name = "${local.project}-${local.env}-eip-webapp"
  }
}

resource "aws_key_pair" "app" {
  key_name   = "${local.project}-${local.env}-app"
  public_key = var.key_pair_pub
}

data "aws_ssm_parameter" "app" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-x86_64"
}
