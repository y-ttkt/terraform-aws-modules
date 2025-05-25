# ===============================================================================
# APP
# ===============================================================================
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
  description              = "SSH from bastion"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion.id
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

resource "aws_security_group_rule" "app_egress_https" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_egress_http" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

# ===============================================================================
# Bastion
# ===============================================================================
data "http" "my_ip" {
  url = "https://api.ipify.org?format=json"
}

locals {
  my_ip = "${jsondecode(data.http.my_ip.response_body)["ip"]}/32"
}

resource "aws_security_group" "bastion" {
  name        = "${local.project}-${local.env}-sg-bastion"
  description = "security group for ${local.project}-${local.env} bastion"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.project}-${local.env}-sg-bastion"
  }
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  security_group_id = aws_security_group.bastion.id
  description       = "SSH from my IP"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [local.my_ip]
}
