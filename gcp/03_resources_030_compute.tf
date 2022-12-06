resource "google_compute_instance" "cp" {
    count = var.num_cps
    project = google_project.project.project_id
    name = "cp${count.index}"
    machine_type = "e2-standard-2"
    zone = var.zone

    boot_disk {
        initialize_params {
            image = "ubuntu-2004-focal-v20221202"
            size = 200
        }
    }

    network_interface {
      subnetwork = google_compute_subnetwork.cp_subnets[count.index].id
      network_ip = cidrhost(google_compute_subnetwork.cp_subnets[count.index].ip_cidr_range, 5)
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

resource "google_compute_instance" "node" {
    count = var.num_nodes
    project = google_project.project.project_id
    name = "node${count.index}"
    machine_type = "e2-standard-2"
    zone = var.zone

    boot_disk {
        initialize_params {
            image = "ubuntu-2004-focal-v20221202"
            size = 20
        }
    }

    network_interface {
      subnetwork = google_compute_subnetwork.node_subnets[count.index].id
      network_ip = cidrhost(google_compute_subnetwork.node_subnets[count.index].ip_cidr_range, 5)
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
        pod-cidr = cidrsubnet(var.pod_cidr_base, 5, count.index)
    }

}

