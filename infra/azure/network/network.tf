
resource "azurerm_resource_group" "net-rg" {
  name     = "${local.net_env}-net_rg"
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "net1" {
  name                = "${local.net_env}-net"
  address_space       = ["${var.cidr_block}"]
  location            = var.location
  resource_group_name = azurerm_resource_group.net-rg.name
}

resource "azurerm_subnet" "subnet" {
  resource_group_name = azurerm_resource_group.net-rg.name
  virtual_network_name = azurerm_virtual_network.net1.name
  count = 2
  name = "subnet${count.index+1}"
  address_prefixes = [cidrsubnet(azurerm_virtual_network.net1.address_space[0], 4, count.index+1)] 
}
