terraform {
   
}

variable "project_id" {
  type = string
}

module "gcp" {
    source = "../gcp"

    num_cps = 3
    num_nodes = 1
    project_id = var.project_id
    service_cidr_base = "10.96.0.0/12"
    haproxy = true
}


output "gcp" {
    value = module.gcp
}