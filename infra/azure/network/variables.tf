variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
}
variable "owner" {
  type        = string
  description = "Owner Name"
}
variable "location" {
  type       = string
  description = "Azure Region"
}
variable "infra_name" {
  type        = string
}
variable "env_name" {
  type        = string
  description = "Name the Environment"
}
variable "cidr_block" { 
  type        = string
  description = "CIDR Block Definition"
}
