output "vm_ipaddress" {
    value = azurerm_public_ip.outsideip.ip_address
}
output "vm_fqdn" {
    value = azurerm_public_ip.outsideip.fqdn
}
