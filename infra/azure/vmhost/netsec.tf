resource "azurerm_network_security_group" "nsg" {
  name                = "${local.hostname}_nsg"
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name
}

resource "azurerm_network_security_rule" "ssh_src1" {
  priority                    = 101
  name                        = "ssh_from_${var.ssh_src1name}"
  source_address_prefix       = var.ssh_src1
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = azurerm_network_interface.nic.private_ip_address
  resource_group_name         = azurerm_resource_group.vm.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}