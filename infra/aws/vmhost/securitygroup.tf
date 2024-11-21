resource "aws_security_group" "devhost" {
  name = "${local.hostname}_sg"
  description = "Security Group to protect DevHost from Public access"
  vpc_id = data.aws_vpc.net.id
  tags = {
    Name = "${local.hostname}_sg"
  }
  # Permit SSH Access from Developer Source IP Address 1
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["${var.ops_ip1}/32"]
  }
  # Permit SSH Access from Developer Source IP Address 2
  # ingress {
  #   protocol = "tcp"
  #   from_port = 22
  #   to_port = 22
  #   cidr_blocks = ["${var.ops_ip2}/32"]
  # }
  # remove this open acl once dev is completed.
  # ingress {
  #   protocol = "tcp"
  #   from_port = 22
  #   to_port = 22
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}