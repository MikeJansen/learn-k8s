resource "google_project" "project" {
    name = "Learn K8s - ${var.project_id_suffix}"
    project_id = "crowsoftware-k8s-${var.project_id_suffix}"
    auto_create_network = false
    billing_account = "0188BB-3F9455-489629"
}

