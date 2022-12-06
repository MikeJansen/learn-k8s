output "project_id" {
    value = google_project.project.project_id
}

output "static_ip_lb" {
    value = google_compute_address.static_ip_lb.address
}

output "cp_ips" {
    value = google_compute_instance.cp[*].network_interface[0].network_ip
}

output "node_ips" {
    value = google_compute_instance.node[*].network_interface[0].network_ip
}

output "num_cps" {
    value = var.num_cps
}

output "num_nodes" {
    value = var.num_nodes
}