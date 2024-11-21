resource "aws_secretsmanager_secret" "ssh_privkey" {
  name_prefix = "${var.hostname}-ssh-privkey_"
  description = "${var.infra_env} - SSH Private Key for ${var.hostname} - ${var.username}"
}

resource "aws_secretsmanager_secret_version" "ssh_privkey" {
  secret_id = aws_secretsmanager_secret.ssh_privkey.id
  secret_string = base64encode(tls_private_key.ssh.private_key_openssh)
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}