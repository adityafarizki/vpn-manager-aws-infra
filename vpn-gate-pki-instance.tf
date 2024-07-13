resource "aws_instance" "vpn_gate_pki_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.vpn_management_instance_type
  subnet_id                   = var.vpn_management_instance_subnet_id
  associate_public_ip_address = true

  iam_instance_profile   = aws_iam_instance_profile.vpn_gate_pki_instance_profile.name
  source_dest_check      = false
  vpc_security_group_ids = [aws_security_group.vpn_gate_pki_instance.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = 10
    volume_type = "gp2"
  }

  user_data                   = local.vpn_gate_pki_instance_user_data
  user_data_replace_on_change = true

  tags = {
    Name = "vpn-gate-pki-instance"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

locals {
  vpn_gate_pki_instance_user_data = templatefile(
    "${path.module}/assets/vpn-gate-pki-setup.sh.tftpl",
    {
      source_full_path = "${aws_s3_bucket.cert_storage.id}/vpn-gate-pki.zip"
      exposed_port     = "80"
      domain           = "vpn.faratas.net"
      use_https        = "true"
      aws_region       = local.current_region
      env_variables = {
        AWS_REGION        = local.current_region
        OIDC_CLIENT_ID    = var.vpn_management_config.oidc_client_id
        OIDC_PROVIDER     = var.vpn_management_config.oidc_provider
        OIDC_AUTH_URL     = var.vpn_management_config.oidc_auth_url
        OIDC_TOKEN_URL    = var.vpn_management_config.oidc_token_url
        OIDC_CERT_URL     = var.vpn_management_config.oidc_cert_url
        OIDC_SCOPES       = var.vpn_management_config.oidc_scopes
        OIDC_REDIRECT_URL = var.vpn_management_config.oidc_redirect_url
        STORAGE_BUCKET    = aws_s3_bucket.cert_storage.id
        ADMIN_EMAIL_LIST  = var.vpn_management_config.admin_email_list
        BASE_URL          = var.vpn_management_config.base_url
        CA_BASE_DIR       = "cav2"
        CONFIG_BASE_DIR   = "cav2"
        VPN_IP_ADDRESSES  = "main=${aws_eip.vpn_ip.public_ip}"
        PORT              = "8080"
        ADDRESS           = "0.0.0.0"
      }

      secrets_variables = {
        OIDC_CLIENT_SECRET = aws_secretsmanager_secret.oidc_client_secret.name
      }
    }
  )
}

resource "aws_security_group" "vpn_gate_pki_instance" {
  name        = "VpnGatePkiInstanceGroup"
  description = "Allow access to http and https port and allow access to aws services"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "vpn_gate_pki_ip" {}

resource "aws_eip_association" "vpn_gate_pki_eip_assoc" {
  instance_id   = aws_instance.vpn_gate_pki_instance.id
  allocation_id = aws_eip.vpn_gate_pki_ip.id
}

resource "aws_iam_instance_profile" "vpn_gate_pki_instance_profile" {
  name = "VpnGatePkiInstanceProfile"
  role = aws_iam_role.vpn_gate_pki_instance_role.name
}

resource "aws_iam_role" "vpn_gate_pki_instance_role" {
  name = "VpnGatePkiInstanceRole"

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

resource "aws_iam_role_policy_attachment" "ssm_gate_pki_instance" {
  role       = aws_iam_role.vpn_gate_pki_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "vpn_gate_pki_instance" {
  role       = aws_iam_role.vpn_gate_pki_instance_role.name
  policy_arn = aws_iam_policy.vpn_gate_pki_process.arn
}

resource "aws_iam_policy" "vpn_gate_pki_process" {
  name   = "VpnGatePkiProcessAccess"
  policy = data.aws_iam_policy_document.vpn_gate_pki_process_access.json
}

data "aws_iam_policy_document" "vpn_gate_pki_process_access" {
  statement {
    sid = "S3Access"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.cert_storage.arn,
      "${aws_s3_bucket.cert_storage.arn}/*"
    ]
  }

  statement {
    sid = "SecretsManagerAccess"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      aws_secretsmanager_secret.oidc_client_secret.arn
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
