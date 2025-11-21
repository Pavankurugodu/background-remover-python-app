resource "aws_vpc" "bgr-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({"Name" = var.name}, var.tags)
}

resource "aws_internet_gateway" "bgr-igw" {
  vpc_id = aws_vpc.bgr-vpc.id
  tags   = merge({"Name" = "${var.name}-igw"}, var.tags)
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }
  vpc_id            = aws_vpc.bgr-vpc.id
  cidr_block        = each.value
  availability_zone = length(var.azs) > 0 ? var.azs[each.key] : null
  map_public_ip_on_launch = true
  tags = merge({"Name" = "${var.name}-public-${each.key}"}, var.tags)
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }
  vpc_id            = aws_vpc.bgr-vpc.id
  cidr_block        = each.value
  availability_zone = length(var.azs) > 0 ? var.azs[each.key] : null
  tags = merge({"Name" = "${var.name}-private-${each.key}"}, var.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge({"Name" = "${var.name}-public-rt"}, var.tags)
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT gateways (brief)
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? length(aws_subnet.public) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

resource "aws_nat_gateway" "gw" {
  count = var.enable_nat_gateway ? length(aws_subnet.public) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.bgr-igw]
  tags = merge({"Name" = "${var.name}-nat-${count.index}"}, var.tags)
}

# Private route tables to use NAT (simple round-robin)
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id = aws_vpc.bgr-vpc.id
  tags = merge({"Name" = "${var.name}-private-rt-${each.key}"}, var.tags)
}

resource "aws_route" "private_default" {
  for_each = aws_route_table.private
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gw[*].id, each.key % length(aws_nat_gateway.gw))
  depends_on             = [aws_nat_gateway.gw]
}
