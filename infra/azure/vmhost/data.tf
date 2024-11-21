data "azurerm_virtual_network" "net1" {
    name                = "${local.net_env}-net"
    resource_group_name = "${local.net_env}-net_rg"
}

data "azurerm_subnet" "subnet1" {
    name                    = "subnet1"
    virtual_network_name    = "${local.net_env}-net"
    resource_group_name     = "${local.net_env}-net_rg"
}

data "azurerm_subnet" "subnet2" {
    name                    = "subnet2"
    virtual_network_name = "${local.net_env}-net"
    resource_group_name = "${local.net_env}-net_rg"
}

data "azurerm_platform_image" "vm_image" {
    location = var.location
    publisher  = "${var.image_publisher}"
    offer = "${var.image_offer}"
    sku = "${var.image_sku}"
}
