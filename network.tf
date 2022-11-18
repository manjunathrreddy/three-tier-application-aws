resource "aws_vpc" "sandbox_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-sandbox_vpc" }))
}

resource "aws_internet_gateway" "sandbox_igw" {
  vpc_id = aws_vpc.sandbox_vpc.id
  tags   = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-sandbox_igw" }))

}

#####################################################
# Public Subnets - Inbound/Outbound Internet Access #
#####################################################
resource "aws_subnet" "sandbox_subnet_public_1" {
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.sandbox_vpc.id
  availability_zone       = "${data.aws_region.current.name}a"

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}

resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}

resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.sandbox_subnet_public_1.id
  route_table_id = aws_route_table.public_rt_1.id
}

resource "aws_route" "public_internet_access_1" {
  route_table_id         = aws_route_table.public_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sandbox_igw.id
}

resource "aws_eip" "public_eip_1" {
  vpc  = true
  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}

resource "aws_nat_gateway" "public_ng_1" {
  depends_on = ["aws_internet_gateway.sandbox_igw"]
  allocation_id = aws_eip.public_eip_1.id
  subnet_id     = aws_subnet.sandbox_subnet_public_1.id

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}
resource "aws_subnet" "sandbox_subnet_public_2" {
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.sandbox_vpc.id
  availability_zone       = "${data.aws_region.current.name}b"

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}

resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))

}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.sandbox_subnet_public_2.id
  route_table_id = aws_route_table.public_rt_2.id
}

resource "aws_route" "public_internet_access_2" {
  route_table_id         = aws_route_table.public_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sandbox_igw.id
}

/*resource "aws_eip" "public_eip_b" {
  vpc = true

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}


resource "aws_nat_gateway" "public_ng_b" {
  allocation_id = aws_eip.public_eip_b.id
  subnet_id     = aws_subnet.sandbox_subnet_public_b.id

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-public" }))
}
*/

###################################################
# Private Subnets - Outbound internet access only #
###################################################
resource "aws_subnet" "sandbox_subnet_private_1" {
  cidr_block        = "10.1.10.0/24"
  vpc_id            = aws_vpc.sandbox_vpc.id
  availability_zone = "${data.aws_region.current.name}a"

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-private" }))
}

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-private" }))
}

resource "aws_route_table_association" "private_rta_1" {
  subnet_id      = aws_subnet.sandbox_subnet_private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route" "private_1_internet_out" {
  route_table_id         = aws_route_table.private_rt_1.id
  nat_gateway_id         = aws_nat_gateway.public_ng_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "sandbox_subnet_private_2" {
  cidr_block        = "10.1.11.0/24"
  vpc_id            = aws_vpc.sandbox_vpc.id
  availability_zone = "${data.aws_region.current.name}b"

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-private" }))
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(local.common_tags, tomap({ "Name" = "${local.prefix}-private" }))
}

resource "aws_route_table_association" "private_rta_2" {
  subnet_id      = aws_subnet.sandbox_subnet_private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

resource "aws_route" "private_2_internet_out" {
  route_table_id         = aws_route_table.private_rt_2.id
  nat_gateway_id         = aws_nat_gateway.public_ng_1.id
  destination_cidr_block = "0.0.0.0/0"
}
