resource "aws_instance" "vpn_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.vpn_instance_type
  subnet_id                   = var.vpn_instance_subnet_id
  associate_public_ip_address = true

  iam_instance_profile   = aws_iam_instance_profile.vpn_instance_profile.name
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.vpn_instance.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 10
    volume_type = "gp2"
  }

  user_data                   = local.vpn_instance_user_data
  user_data_replace_on_change = true

  tags = {
    Name = "vpn-instance"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

# building vpn instance user_data
locals {
  vpn_instance_user_data = templatefile(
    "${path.module}/assets/openvpn-install.sh.tftpl",
    {
      vpn_subnet_address = var.vpn_ip_config.vpn_subnet_address
      vpn_subnet_mask    = var.vpn_ip_config.vpn_subnet_mask
      vpn_subnet_cidr    = var.vpn_ip_config.vpn_subnet_cidr
      vpn_data_s3_bucket = aws_s3_bucket.cert_storage.id
      vpn_port           = "1194"
    }
  )
}

resource "aws_eip" "vpn_ip" {}

resource "aws_eip_association" "vpn_eip_assoc" {
  instance_id   = aws_instance.vpn_instance.id
  allocation_id = aws_eip.vpn_ip.id
}

resource "aws_security_group" "vpn_instance" {
  name        = "VpnInstanceGroup"
  description = "Allow access to vpn port and allow access to aws services"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "vpn_instance_profile" {
  name = "VpnInstanceProfile"
  role = aws_iam_role.vpn_instance_role.name
}

resource "aws_iam_role" "vpn_instance_role" {
  name = "VpnInstanceRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_instance" {
  role       = aws_iam_role.vpn_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "vpn_instance" {
  role       = aws_iam_role.vpn_instance_role.name
  policy_arn = aws_iam_policy.vpn_process.arn
}

resource "aws_iam_policy" "vpn_process" {
  name   = "VpnProcessAccess"
  policy = data.aws_iam_policy_document.vpn_process_access.json
}

data "aws_iam_policy_document" "vpn_process_access" {
  statement {
    sid = "S3Access"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectVersion",
    ]

    resources = [
      aws_s3_bucket.cert_storage.arn,
      "${aws_s3_bucket.cert_storage.arn}/*"
    ]
  }

  statement {
    sid = "CloudwatchAccess"

    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      "*",
    ]
  }
}
