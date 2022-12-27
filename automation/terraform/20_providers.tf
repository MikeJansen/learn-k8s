provider "google" {
  region = var.region
  zone = var.zones[0]
  project = var.project_id
}