module "devhost" {
  source = "../modules/devhost"
  aws_region  = var.aws_region
  hostname    = local.hostname
  username    = var.username
  image_id    = data.aws_ami.ubuntu.id
  disk_size   = 50
  infra_env   = local.infra_env
  pubkey1     = var.pubkey1
  secgroup-id = aws_security_group.devhost.id
}