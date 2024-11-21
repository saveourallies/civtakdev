terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {}
}
provider "aws" {
    region = var.aws_region
    default_tags {
      tags = local.tags
    }
}

locals {
  infra_env = "${var.infra_name}-${var.env_name}"
  tags   = {
    network = var.infra_name
    environment = var.env_name
    infra_group = var.component
    owner       = var.owner
  }
}