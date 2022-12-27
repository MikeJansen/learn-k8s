resource "google_compute_firewall" "firewall_intra_cp_ingress" {
  name = "intra-cp-ingress"
  network = google_compute_network.network.id
  direction = "INGRESS"
  source_ranges = [ google_compute_subnetwork.cp_subnet.ip_cidr_range ]
  target_tags = [ "k8s-cp" ]
  allow { 
    protocol = "tcp"
    ports = [ "6443", "2379-2380", "10250", "10259", "10257" ]
  }
}

resource "google_compute_firewall" "firewall_cp_to_worker" {
  name = "cp-to-worker"
  network = google_compute_network.network.id
  direction = "INGRESS"
  source_ranges = [ google_compute_subnetwork.cp_subnet.ip_cidr_range ]
  target_tags = [ "k8s-worker" ]
  allow {
    protocol = "tcp"
    ports = [ "10250", "30000-32767" ]
  }
}

resource "google_compute_firewall" "firewall_worker_to_cp" {
  name = "worker-to-cp"
  network = google_compute_network.network.id
  direction = "INGRESS"
  source_ranges = [ google_compute_subnetwork.worker_subnet.ip_cidr_range ]
  target_tags = [ "k8s-cp" ]
  allow {
    protocol = "tcp"
    ports = [ "6443", "30000-32767" ]
  }
}

resource "google_compute_firewall" "firewall_worker_to_worker" {
  name = "worker-to-worker"
  network = google_compute_network.network.id
  direction = "INGRESS"
  source_ranges = [ google_compute_subnetwork.worker_subnet.ip_cidr_range ]
  target_tags = [ "k8s-worker" ]
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "firewall_trusted_cp_ingress" {
  name = "trusted-cp-ingress"
  network = google_compute_network.network.id
  direction = "INGRESS"
  source_ranges = var.trusted_cidrs
  target_tags = [ "k8s-cp" ]
  allow {
    protocol = "tcp"
    ports = [ "22", "6443", "30000-32767"]
  }
  allow { 
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "firewall_trusted_worker_ingress" {
  name = "trusted-worker-ingress"
  network = google_compute_network.network.id
  direction = "INGRESS"
  source_ranges = var.trusted_cidrs
  target_tags = [ "k8s-worker" ]
  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }
  allow { 
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "firewall_egress" {
  name = "egress"
  network = google_compute_network.network.id
  direction = "EGRESS"
  allow {
    protocol = "all"
  }
}