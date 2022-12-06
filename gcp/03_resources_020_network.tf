resource "google_compute_network" "network" {
    project = google_project.project.project_id
    name = "network"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cp_subnets" {
    count = var.num_cps
    project = google_project.project.project_id
    name = "cpsubnet${count.index}"
    ip_cidr_range = cidrsubnet(local.cp_cidr_base, 7, count.index)
    region = var.region
    network = google_compute_network.network.id
}

resource "google_compute_subnetwork" "node_subnets" {
    count = var.num_nodes
    project = google_project.project.project_id
    name = "nodesubnet${count.index}"
    ip_cidr_range = cidrsubnet(local.node_cidr_base, 7, count.index)
    region = var.region
    network = google_compute_network.network.id
}

resource "google_compute_address" "static_ip_lb" {
    name = "static-ip-lb"
    project = google_project.project.project_id
}

