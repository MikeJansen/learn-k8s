terraform {
   
}

module "gcp" {
    source = "../../gcp"

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

output "pod_cidr_base" {
    value = module.gcp.pod_cidr_base
}

output "service_cidr_base" {
    value = module.gcp.service_cidr_base
}
