terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
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
    environment   = var.env_name
    infra_group   = var.infra_name
    component     = var.component
    owner         = var.owner
  }
}