terraform {
   
}

module "gcp" {
    source = "../../gcp"

    project_id_suffix = "hardway-04"
    num_cps = 3
    num_nodes = 3
}

output "static_ip_lb" {
    value = module.gcp.static_ip_lb
}

output "project_id" {
    value = module.gcp.project_id
}

output "cp_ips" {
    value = module.gcp.cp_ips
}

output "node_ips" {
    value = module.gcp.node_ips
}

output "num_cps" {
    value = module.gcp.num_cps
}

output "num_nodes" {
    value = module.gcp.num_nodes
}
