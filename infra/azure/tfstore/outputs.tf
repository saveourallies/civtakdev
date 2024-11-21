output "tfstate_rg" {
  value = "${azurerm_storage_account.tfstate.resource_group_name}"
}
output "tfstate_name" {
  value = "${azurerm_storage_account.tfstate.name}"
}
output "tfstate_kind" {
  value = "${azurerm_storage_account.tfstate.account_kind}"
}
output "tfstate_tier" {
  value = "${azurerm_storage_account.tfstate.account_tier}"
}
output "tfstate_replication" {
  value = "${azurerm_storage_account.tfstate.account_replication_type}"
}
