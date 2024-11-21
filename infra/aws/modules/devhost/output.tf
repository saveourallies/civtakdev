output "ec2instance_ip" {
    value = aws_instance.devhost.public_ip
}
output "ec2instance_dns" {
    value = aws_instance.devhost.public_dns
}
output "ssh_publickey" {
  value = tls_private_key.ssh.public_key_openssh
}
output "ssh_publickey_label" {
  value = "${var.infra_env}-${var.hostname}-${var.username}"
}



