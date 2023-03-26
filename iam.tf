resource "aws_iam_instance_profile" "vpn_server_profile" {
  name = "VPNServerProfile"
  role = aws_iam_role.vpn_server_role.name
}

resource "aws_iam_role" "vpn_server_role" {
  name = "VPNServerRole"

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

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}