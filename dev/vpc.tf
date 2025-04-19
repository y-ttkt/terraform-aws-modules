# ===============================================================================
# VPC
# ===============================================================================
resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  enable_dns_hostnames             = false
  enable_dns_support               = true
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "${local.project}-${local.env}-vpc-web"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.project}-${local.env}-igw-web"
  }
}

# ===============================================================================
# public subnet
# ===============================================================================
resource "aws_subnet" "public" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.project}-${local.env}-public-${local.az_suffix[local.availability_zones[count.index]]}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.project}-${local.env}-rt-public"
  }
}

resource "aws_route" "default_gw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(local.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ===============================================================================
# protected subnet
# ===============================================================================
resource "aws_subnet" "protected" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, (count.index + 1) * 10) # 10,20
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.project}-${local.env}-protected-${local.az_suffix[local.availability_zones[count.index]]}"
  }
}

# ===============================================================================
# private subnet
# ===============================================================================
resource "aws_subnet" "private" {
  count                   = length(local.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, (count.index + 1) * 100) # 100,200
  availability_zone       = local.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.project}-${local.env}-private-${local.az_suffix[local.availability_zones[count.index]]}"
  }
}
