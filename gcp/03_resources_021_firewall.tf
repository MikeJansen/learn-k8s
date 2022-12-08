resource "google_compute_firewall" "firewall" {
    project = google_project.project.project_id
    name = "ingress-ssh"
    network = google_compute_network.network.id
    direction = "INGRESS"
    source_ranges = [
        "173.90.193.167/32",
        "75.185.174.135/32"
    ]
    allow {
        protocol = "tcp"
        ports = [ "22", "6443" ]
    }
    allow {
        protocol = "icmp"
    }
}

resource "google_compute_firewall" "firewall_internal" {
    project = google_project.project.project_id
    name = "ingress-internal"
    network = google_compute_network.network.id
    direction = "INGRESS"
    source_ranges = [
        var.vpc_cidr,
        var.pod_cidr_base
    ]
    allow {
        protocol = "all"
    }
}

resource "google_compute_firewall" "firewall_egress" {
    project = google_project.project.project_id
    name = "egress"
    network = google_compute_network.network.id
    direction = "EGRESS"
    allow {
        protocol = "all"
    }
}

