module "vpn_vpc" {
  count  = local.vpc_id != null ? 0 : 1
  source = "terraform-aws-modules/vpc/aws"

  name = "vpn-vpc"
  cidr = "10.0.0.0/16"

  azs            = data.aws_availability_zones.region_azs.names
  public_subnets = [for i, az in data.aws_availability_zones.region_azs.names : "10.0.10${i * 2}.0/23"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}
