variable "aws_region" {
  type        = string
  description = "AWS Region"
}
variable "component" {
  type        = string
  description = "System Component Name - Name the Terraform Group"
  default     = "init"
}
variable "env_name" {
  description = "Name of Deployment (environment)"
}
variable "owner" {
  type        = string
  description = "Owner Name"
  default = "DevOps"
}
variable "tfstate_bucketname" {
  description = "Name of TF State Bucket to create"
}
variable "infra_name" {
  type        = string
  description = "name the Infrastructure"
}
