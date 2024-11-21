resource "azurerm_resource_group" "oam" {
  name     = "${var.tfstate_rg}"
  location = "${var.location}"
}
resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.tfstate_account}"
  resource_group_name      = azurerm_resource_group.oam.name
  location                 = azurerm_resource_group.oam.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "blob" {
  name                  = "${var.tfstate_container}"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
