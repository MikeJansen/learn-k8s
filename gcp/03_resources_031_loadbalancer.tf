resource "google_compute_http_health_check" "kubernetes" {
    # project = google_project.project.project_id
    name = "kubernetes"
    description = "Kubernetes health check"
    host = "kubernetes.default.svc.cluster.local"
    request_path = "/healthz"
}

resource "google_compute_firewall" "kubernetes-allow-health-check" {
    # project = google_project.project.project_id
    name = "kubernetes-allow-health-check"
    network = google_compute_network.network.name
    source_ranges = [ 
        "209.85.152.0/22",
        "209.85.204.0/22",
        "35.191.0.0/16"
    ]
    allow {
        protocol = "tcp"
        ports = [ "80" ]
    }
}

resource "google_compute_target_pool" "kubernetes_target_pool" {
    # project = google_project.project.project_id
    name = "kubernetes-target-pool"
    health_checks = [
        google_compute_http_health_check.kubernetes.id
    ]
    instances = google_compute_instance.cp[*].self_link
}

resource "google_compute_forwarding_rule" "kubernetes_forwarding_rule" {
    # project = google_project.project.project_id
    name = "kubernetes-forwarding-rule"
    port_range = "6443-6443"
    ip_address = google_compute_address.static_ip_lb.address
    target = google_compute_target_pool.kubernetes_target_pool.id
    region = var.region
}
