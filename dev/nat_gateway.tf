resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${local.project}-${local.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  # 各AZに配置した方が良いのだが、コスト削減のため一旦単一のAZに配置
  subnet_id  = aws_subnet.public[0].id
  depends_on = [aws_internet_gateway.main] # IGW が先にできている必要がある

  tags = {
    Name = "${local.project}-${local.env}-natgw-a"
  }
}
