resource "aws_secretsmanager_secret" "oidc_client_secret" {
  name        = "OIDC_CLIENT_SECRET"
  description = "Secret for OIDC Client Secret"
}
