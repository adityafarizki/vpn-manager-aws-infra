resource "aws_instance" "vpn_server" {
  ami                         = data.aws_ami.vpn_server_amin.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vpn_server_profile.arn
  instance_type               = var.vpn_instance_type
  security_groups             = [aws_security_group.vpn_server_sg.id]
  source_dest_check           = false
  vpc_security_group_ids      = [local.vpc_id]
  user_data                   = file("${path.module}/openvpn-setup.sh")

  root_block_device {
    encrypted   = true
    volume_size = 10
  }
}

data "aws_ami" "vpn_server_amin" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "vpn_server_sg" {
  name        = "vpn_server_sg"
  description = "Allow VPN inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "UDP connection for VPN"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP connection for VPN"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}