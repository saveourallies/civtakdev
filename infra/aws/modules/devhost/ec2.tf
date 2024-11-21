resource "aws_instance" "devhost" {
  ami = var.image_id
  instance_type = var.instance_type
  subnet_id = tolist(data.aws_subnets.public.ids)[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [var.secgroup-id]
  user_data = templatefile(
    "${path.module}/scripts/cloud-init.yaml", {
      hostname = var.hostname,
      username = var.username,
      pubkey1 = var.pubkey1,
      pubkey2 = tls_private_key.ssh.public_key_openssh
    }
  )
  root_block_device {
    volume_size = var.disk_size
  }
  lifecycle {
    ignore_changes = [
      user_data,
      ami
    ]
  }
  tags = {
    Name = "${var.hostname}"
  }
}
