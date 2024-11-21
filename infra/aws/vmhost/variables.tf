variable "aws_region" {
  type        = string
  description = "AWS Region"
}
variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
  default     = "devhost"
}
variable "owner" {
  type        = string
  description = "Owner Name"
  default = "DevOps"
}
variable "infra_name" {
  type        = string
  description = "Name the Infrastructure"
}
variable "env_name" {
  type        = string
  description = "Name the Environment"
}
variable "ops_ip1" {
  type        = string
  description = "Remote IP1 for SSH - Kris Thompson Office"
}
variable "host_tag" {
  type        = string
  description = "short tag to track owner in hostname"
  default = "jump1"
}
variable "username" {
  type        = string
  description = "username for host login"
  default = "devadmin"
}
variable "pubkey1" {
  type        = string
  description = "pubkey1 - shared devops host login key"
}

