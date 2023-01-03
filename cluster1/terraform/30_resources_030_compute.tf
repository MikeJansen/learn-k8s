resource "google_compute_instance" "cp" {
  count = var.num_cps
  name = "cp${count.index}"
  machine_type = "e2-standard-2"
  zone = local.node_zones[count.index]
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20221202"
      size = 200
    }
  }
  labels = {
    role = "k8s"
    k8s_role = "cp"
  }
  tags = [ "k8s-cp" ]
  network_interface {
    subnetwork = google_compute_subnetwork.cp_subnet.id
    network_ip = cidrhost(
              google_compute_subnetwork.cp_subnet.ip_cidr_range, 
              5 + count.index)
    access_config {
    }
  }
  can_ip_forward = true
  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }
}

resource "google_compute_instance" "worker" {
  count = var.num_workers
  name = "worker${count.index}"
  machine_type = "e2-standard-2"
  zone = local.node_zones[count.index]
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20221202"
      size = 200
    }
  }
  labels = {
    role = "k8s"
    k8s_role = "worker"
  }
  tags = [ "k8s-worker" ]
  network_interface {
    subnetwork = google_compute_subnetwork.worker_subnet.id
    network_ip = cidrhost(
              google_compute_subnetwork.worker_subnet.ip_cidr_range, 
              5 + count.index)
    access_config {
    }
  }
  can_ip_forward = true
  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }
  metadata = {
    "pod-cidr" = local.pod_node_cidrs[count.index]
  }
}
