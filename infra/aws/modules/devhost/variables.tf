variable "aws_region" {
  type        = string
  description = "AWS Region"
}
variable "infra_env" {
  type = string
}
variable "instance_type" {
  type = string
  description = "Type of VM"
  default = "t3.medium"
}
variable "disk_size" {
  type = number
  description = "Disk size for EC2 Instance"
  default = 50
}
variable "image_id" {
  type = string
  description = "provide AMI image_id (OS) for EC2 Instance (VM)"
}
variable "hostname" {
  type = string
  description = "hostname for host and security group"
}
variable "username" {
  type = string
  description = "username for login"
}
variable "pubkey1" {
  type = string
  description = "ssh public key 1"
}
# variable "pubkey2" {
#   type = string
#   description = "ssh public key 2"
# }
# variable "pubkey3" {
#   type = string
#   description = "ssh public key 3"
# }
variable "secgroup-id" {
  type = string
  description = "Security Group ID"
}