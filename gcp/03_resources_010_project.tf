resource "random_id" "project_id_suffix" {
    byte_length = 2
}

resource "google_project" "project" {
    name = "Learn K8s - ${random_id.project_id_suffix.hex}"
    project_id = "learn-k8s-${random_id.project_id_suffix.hex}"
    auto_create_network = false
    billing_account = "0188BB-3F9455-489629"
}

