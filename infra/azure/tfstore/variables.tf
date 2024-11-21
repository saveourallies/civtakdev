variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
  default     = "tfstore"
}
variable "owner" {
  type        = string
  description = "Owner Name"
  default = "DevOps"
}
variable "location" {
  type       = string
  description = "Azure Region"
  # default     = "eastus"
}
variable "infra_name" {
  type        = string
  description = "Name the Net"
  default    = "net1"
}
variable "env_name" {
  type        = string
  description = "Name the Environment"
}
variable "tfstate_rg" {
  type        = string
  description = "Resource Group name for TF State Storage"
}
variable "tfstate_account" {
  type        = string
  description = "Storage Account name for TF State Storage"
}
variable "tfstate_container" {
  type        = string
  description = "Blob Container name for TF State Storage"
}
