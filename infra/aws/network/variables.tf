variable "aws_region" {
  type        = string
  description = "AWS Region"
}
variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
  default     = "network"
}
variable "owner" {
  type        = string
  description = "Owner Name"
  default = "DevOps"
}
variable "infra_name" {
  type        = string
  description = "Name the Net"
}
variable "env_name" {
  type        = string
  description = "Name the Environment"
}
variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}
variable "cidr_block" { 
  type        = string
  description = "CIDR Block Definition e.g. 10.250.128.0/20"
}

# variable "dns_parent" { 
#   type        = string
#   description = "Parent DNS Zone"
#   default     =  "parent.example.com"
# }
# variable "clientdns_parent" { 
#   type        = string
#   description = "Parent Client DNS Zone"
#   default     =  "app.example.com"
# }