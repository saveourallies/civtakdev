variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
}
variable "owner" {
  type        = string
  description = "Owner Name"
}
variable "location" {
  type = string
  description = "Azure Location aka Region"
}
variable "infra_name" {
  type        = string
  description = "Name the Infra"
}
variable "env_name" {
  type        = string
  description = "Name the Environment"
}
variable "vm_name" {
  type = string
  description = "Name the Virtual Machine"
}
variable "vm_user" {
  type = string
  description = "Set the Username for Linux login"
}
variable "vm_size" {
  type = string
  description = "Size of Azure VM"
}
variable "image_publisher" {
  type = string
  description = "Publisher Name on Azure"
}
variable "image_offer" {
  type = string
  description = "Offer Name on Azure"
}
variable "image_sku" {
  type = string
  description = "SKU Name on Azure"
}
variable "ssh_src1" {
  type = string
  description = "ssh source ip address 1"
}
variable "ssh_pubkey1" {
  type = string
  description = "ssh public key"
}
variable "ssh_src1name" {
  type = string
  description = "ssh source name 1"
}
