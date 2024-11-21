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
  type       = string
  description = "Azure Region"
  # default     = "eastus"
}
variable "infra_name" {
  type        = string
  description = "Name the Net"
}
variable "env_name" {
  type        = string
  description = "Name the Environment"
}
variable "cidr_block" { 
  type        = string
  description = "CIDR Block Definition e.g. 10.250.128.0/17"
}
# variable "timezone" {
#   # default = "America/Chicago"
# }
