variable "region" {
  type        = string
  description = "region for the resources"
}

variable "vpn_instance_type" {
  type        = string
  default     = "t3.nano"
  description = "instance type for the vpn instance"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "vpc id if you want to use existing vpc"
}