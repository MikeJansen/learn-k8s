terraform {
   
}

variable "project_id" {
  type = string
}

module "gcp" {
    source = "../../gcp"

    num_cps = 3
    num_nodes = 3
    project_id = var.project_id
}

output "gcp" {
    value = module.gcp
}