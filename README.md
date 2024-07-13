# VPN Gate PKI AWS Infrastructure

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 5.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | 5.55.0  |

## Modules

| Name                                         | Source                        | Version |
| -------------------------------------------- | ----------------------------- | ------- |
| <a name="module_vpc"></a> [vpc](#module_vpc) | terraform-aws-modules/vpc/aws | n/a     |

## Resources

| Name                                                                                                                                                                | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_eip.vpn_gate_pki_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                          | resource    |
| [aws_eip.vpn_ip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                                   | resource    |
| [aws_eip_association.vpn_eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association)                                    | resource    |
| [aws_eip_association.vpn_gate_pki_eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association)                           | resource    |
| [aws_iam_instance_profile.vpn_gate_pki_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)          | resource    |
| [aws_iam_instance_profile.vpn_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)                   | resource    |
| [aws_iam_policy.vpn_gate_pki_process](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                       | resource    |
| [aws_iam_policy.vpn_process](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                                | resource    |
| [aws_iam_role.vpn_gate_pki_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role.vpn_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                              | resource    |
| [aws_iam_role_policy_attachment.ssm_gate_pki_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_iam_role_policy_attachment.ssm_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)               | resource    |
| [aws_iam_role_policy_attachment.vpn_gate_pki_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)      | resource    |
| [aws_iam_role_policy_attachment.vpn_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)               | resource    |
| [aws_instance.vpn_gate_pki_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                          | resource    |
| [aws_instance.vpn_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                                                   | resource    |
| [aws_s3_bucket.cert_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                 | resource    |
| [aws_s3_bucket_lifecycle_configuration.cert_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource    |
| [aws_s3_bucket_public_access_block.cert_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)         | resource    |
| [aws_s3_bucket_versioning.cert_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)                           | resource    |
| [aws_secretsmanager_secret.oidc_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)                   | resource    |
| [aws_security_group.vpn_gate_pki_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                              | resource    |
| [aws_security_group.vpn_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)                                       | resource    |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                                                                | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                       | data source |
| [aws_iam_policy_document.vpn_gate_pki_process_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)           | data source |
| [aws_iam_policy_document.vpn_process_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                    | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                         | data source |

## Inputs

| Name                                                                                                                                 | Description                                                                                                                     | Type                                                                                                                                                                                                                                                                            | Default                                                                                                                      | Required |
| ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                                                  | id of the vpc to be used by the vpn system                                                                                      | `string`                                                                                                                                                                                                                                                                        | n/a                                                                                                                          |   yes    |
| <a name="input_vpn_instance_subnet_id"></a> [vpn_instance_subnet_id](#input_vpn_instance_subnet_id)                                  | id of the subnet to be used by the vpn instance                                                                                 | `string`                                                                                                                                                                                                                                                                        | n/a                                                                                                                          |   yes    |
| <a name="input_vpn_instance_type"></a> [vpn_instance_type](#input_vpn_instance_type)                                                 | aws instance type code for the vpn instance                                                                                     | `string`                                                                                                                                                                                                                                                                        | `"t3.micro"`                                                                                                                 |    no    |
| <a name="input_vpn_ip_config"></a> [vpn_ip_config](#input_vpn_ip_config)                                                             | vpn ip adresses config                                                                                                          | <pre>object({<br> vpn_subnet_address = string<br> vpn_subnet_mask = string<br> vpn_subnet_cidr = string<br> })</pre>                                                                                                                                                            | <pre>{<br> "vpn_subnet_address": "10.8.0.0",<br> "vpn_subnet_cidr": "/24",<br> "vpn_subnet_mask": "255.255.255.0"<br>}</pre> |    no    |
| <a name="input_vpn_management_config"></a> [vpn_management_config](#input_vpn_management_config)                                     | the environment variables value for the vpn gate pki system, refer to https://github.com/adityafarizki/vpn-manager-pki for docs | <pre>object({<br> oidc_client_id = string<br> oidc_auth_url = string<br> oidc_token_url = string<br> oidc_cert_url = string<br> oidc_redirect_url = string<br> oidc_scopes = string<br> oidc_provider = string<br> admin_email_list = string<br> base_url = string<br> })</pre> | n/a                                                                                                                          |   yes    |
| <a name="input_vpn_management_instance_subnet_id"></a> [vpn_management_instance_subnet_id](#input_vpn_management_instance_subnet_id) | id of the subnet to be used by the vpn management instance                                                                      | `string`                                                                                                                                                                                                                                                                        | n/a                                                                                                                          |   yes    |
| <a name="input_vpn_management_instance_type"></a> [vpn_management_instance_type](#input_vpn_management_instance_type)                | aws instance type code for the vpn management instance                                                                          | `string`                                                                                                                                                                                                                                                                        | `"t3.nano"`                                                                                                                  |    no    |

## Outputs

No outputs.
