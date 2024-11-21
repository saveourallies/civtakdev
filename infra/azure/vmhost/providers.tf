terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.78"
    }
  }
  backend "azurerm" {}
}
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
      skip_shutdown_and_force_delete = true
    }
  }
}

locals {
  net_env = "${var.infra_name}-${var.env_name}"
  hostname = "${var.infra_name}-${var.env_name}-${var.vm_name}"
  tags   = {
    network     = var.infra_name
    environment = var.env_name
    infra_group = var.component
    owner       = var.owner
  }
}