locals {
  vpc_id = var.vpc_id != null ? var.vpc_id : module.vpn_vpc[0].id
}