data "aws_vpc" "net" {
  filter {
    name   = "tag:Name"
    values = ["${var.infra_env}-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.net.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.infra_env}-pub*"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.net.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.infra_env}-priv*"]
  }
}

