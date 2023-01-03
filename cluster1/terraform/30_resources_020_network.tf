resource "google_compute_network" "network" {
  name = "network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cp_subnet" {
  name = "cp"
  ip_cidr_range = local.cp_cidr_base
  region = var.region
  network = google_compute_network.network.id
}

resource "google_compute_subnetwork" "worker_subnet" {
  name = "worker"
  ip_cidr_range = local.worker_cidr_base
  region = var.region
  network = google_compute_network.network.id
}