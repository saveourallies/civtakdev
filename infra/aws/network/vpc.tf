resource "aws_vpc" "net" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${local.infra_env}-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = var.az_count
  vpc_id            = aws_vpc.net.id
  cidr_block        = cidrsubnet(aws_vpc.net.cidr_block, 4, count.index + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${local.infra_env}-pub${count.index + 1}"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = var.az_count
  vpc_id            = aws_vpc.net.id
  cidr_block        = cidrsubnet(aws_vpc.net.cidr_block, 4, count.index + 5)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${local.infra_env}-priv${count.index + 1}"
  }
  map_public_ip_on_launch = "false"
}

resource "aws_subnet" "db" {
  count             = var.az_count
  vpc_id            = aws_vpc.net.id
  cidr_block        = cidrsubnet(aws_vpc.net.cidr_block, 4, count.index + 9)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${local.infra_env}-db${count.index + 1}"
  }
  map_public_ip_on_launch = "false"
}

resource "aws_db_subnet_group" "private" {
  name       = "${local.infra_env}-dbprivate"
  subnet_ids = aws_subnet.db.*.id
}

resource "aws_db_subnet_group" "public" {
  name       = "${local.infra_env}-dbpublic"
  subnet_ids = aws_subnet.public.*.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.net.id
  tags = {
    Name = "${local.infra_env}-gw"
  }
}

