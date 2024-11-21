resource "aws_eip" "nat_eip" {
  count = var.az_count
  domain   = "vpc"
  tags = {
    Name = "${local.infra_env}-nat_eip${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.az_count
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags = {
    Name = "${local.infra_env}-nat-gw${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.net.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${local.infra_env}-pub-rtb"
  }
}

resource "aws_route_table" "priv_rtb" {
  count  = var.az_count
  vpc_id = aws_vpc.net.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  tags = {
    Name = "${local.infra_env}-priv${count.index + 1}-rtb"
  }
}

resource "aws_route_table" "db_rtb" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "${local.infra_env}-db-rtb"
  }
}

resource "aws_route_table_association" "public_rtb_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pub_rtb.id
}

resource "aws_route_table_association" "private_rtb_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.priv_rtb[count.index].id
}

resource "aws_route_table_association" "db_rtb_assoc" {
  count          = var.az_count
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db_rtb.id
}

