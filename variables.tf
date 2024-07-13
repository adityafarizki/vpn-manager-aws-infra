variable "vpc_id" {
  type        = string
  description = "id of the vpc to be used by the vpn system"
}

variable "vpn_instance_subnet_id" {
  type        = string
  description = "id of the subnet to be used by the vpn instance"
}

variable "vpn_management_instance_subnet_id" {
  type        = string
  description = "id of the subnet to be used by the vpn management instance"
}

variable "vpn_instance_type" {
  type        = string
  description = "aws instance type code for the vpn instance"
  default     = "t3.micro"
}

variable "vpn_management_instance_type" {
  type        = string
  description = "aws instance type code for the vpn management instance"
  default     = "t3.nano"
}

variable "vpn_ip_config" {
  type = object({
    vpn_subnet_address = string
    vpn_subnet_mask    = string
    vpn_subnet_cidr    = string
  })
  description = "vpn ip adresses config"
  default = {
    vpn_subnet_address = "10.8.0.0"
    vpn_subnet_mask    = "255.255.255.0"
    vpn_subnet_cidr    = "/24"
  }
}

variable "vpn_management_config" {
  type = object({
    oidc_client_id    = string
    oidc_auth_url     = string
    oidc_token_url    = string
    oidc_cert_url     = string
    oidc_redirect_url = string
    oidc_scopes       = string
    oidc_provider     = string
    admin_email_list  = string
    base_url          = string
  })
  description = "the environment variables value for the vpn gate pki system, refer to https://github.com/adityafarizki/vpn-manager-pki for docs"
}
