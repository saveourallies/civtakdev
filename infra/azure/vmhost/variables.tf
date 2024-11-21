variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
}
variable "owner" {
  type        = string
  description = "Owner Name"
  default = "DevOps"
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
  default = "Standard_B2s"
  # https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
}
variable "image_publisher" {
  type = string
  description = "Publisher Name on Azure"
  default = "Canonical"
}
variable "image_offer" {
  type = string
  description = "Offer Name on Azure"
  default = "0001-com-ubuntu-server-jammy"
}
variable "image_sku" {
  type = string
  description = "SKU Name on Azure"
  default = "22_04-lts-gen2"
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
# variable "pubkey1_file" {
#   type = string
#   description = "public ssh key 1 for devops remote access"
# }
# variable "pubkey2_file" {
#   type = string
#   description = "public ssh key 2 for devops remote access"
# }
# variable "admin_pass" {
#   type = string
#   description = "linux default user password"
# }