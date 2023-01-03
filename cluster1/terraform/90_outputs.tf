output "static_ip_lb" {
    value = google_compute_address.static_ip_lb.address
}

output "cp_ips" {
    value = google_compute_instance.cp[*].network_interface[0].network_ip
}

output "worker_ips" {
    value = google_compute_instance.worker[*].network_interface[0].network_ip
}

output "num_cps" {
    value = var.num_cps
}

output "num_workers" {
    value = var.num_workers
}

output "pod_cidr_base" {
    value = var.pod_cidr_base
}

output "service_cidr_base" {
    value = var.service_cidr_base
}

output "service_ip" {
    value = local.service_ip
}

output "cluster_dns_ip" {
    value = local.cluster_dns_ip
}

output "pod_node_cidrs" {
    value = local.pod_node_cidrs
}

output "project_id" {
    value = var.project_id
}

output "region" {
    value = var.region
}

output "zone" {
    value = var.zones[0]
}

output "zones" {
  value = var.zones
}
