terraform {
   
}

variable "include_loadbalancer" {
  default = false
  type = bool
}

module "gcp" {
    source = "../../gcp"

    num_cps = 3
    num_nodes = 3
    include_loadbalancer = var.include_loadbalancer
}

output "gcp" {
    value = module.gcp
}