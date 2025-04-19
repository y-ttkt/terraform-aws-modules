# ===============================================================================
# APP
# ===============================================================================
data "http" "my_ip" {
  url = "https://api.ipify.org?format=json"
}

locals {
  my_ip = "${jsondecode(data.http.my_ip.response_body)["ip"]}/32"
}

resource "aws_security_group" "app" {
  name        = "${local.project}-${local.env}-sg-webapp"
  description = "security group for ${local.project}-${local.env} app"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.project}-${local.env}-sg-webapp"
  }
}

resource "aws_security_group_rule" "app_ingress_ssh" {
  security_group_id = aws_security_group.app.id
  description       = "SSH from my IP"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [local.my_ip]
}

resource "aws_security_group_rule" "app_ingress_http" {
  security_group_id = aws_security_group.app.id
  description       = "http"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
