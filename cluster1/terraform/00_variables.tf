variable "project_id" {
  type = string
}

variable "region" {
  default = "us-east4"
  type    = string
}

variable "zones" {
  default = ["us-east4-a", "us-east4-b", "us-east4-c"]
  type    = list(any)
}

variable "num_cps" {
  default     = 1
  type        = number
  description = "Number of Control Plane nodes"
}

variable "num_workers" {
  default     = 1
  type        = number
  description = "Number of Worker nodes"
}

variable "vpc_cidr" {
  default     = "10.42.0.0/16"
  type        = string
  description = "VPC CIDR"
}

variable "pod_cidr_base" {
  default     = "10.200.0.0/16"
  type        = string
  description = "Base CIDR for pod cidrs"
}

variable "service_cidr_base" {
  default     = "10.32.0.0/24"
  type        = string
  description = "Base CIDR for pod cidrs"
}

variable "subnet_bits" {
  default     = 3
  type        = number
  description = "Number of bits of VPC CIDR for subnets"
}

variable "cp_node_offset" {
  default     = 0
  type        = number
  description = "Subnet number for Control Plane nodes"
}

variable "worker_node_offset" {
  default     = 1
  type        = number
  description = "Subnet number for Worker nodes"
}

variable "trusted_cidrs" {
    default = [
        "173.90.193.167/32"
    ]
    type = list
    description = "List of trusted CIDRs for SSH, etc"
}

locals {
  cp_cidr_base   = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.cp_node_offset)
  worker_cidr_base = cidrsubnet(var.vpc_cidr, var.subnet_bits, var.worker_node_offset)
  service_ip     = cidrhost(var.service_cidr_base, 1)
  cluster_dns_ip = cidrhost(var.service_cidr_base, 10)
  pod_node_cidrs = [
    for idx in range(var.num_workers) :
      cidrsubnet(var.pod_cidr_base, 5, idx)
  ]
  node_zones = [
    for idx in range(max(var.num_cps, var.num_workers)) :
      var.zones[idx % length(var.zones)]
  ]
}
