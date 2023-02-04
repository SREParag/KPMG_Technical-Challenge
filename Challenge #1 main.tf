provider "google" {
  credentials = file("path/to/credentials.json")
  project     = var.project_id
}
resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = true
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name          = "my-subnetwork"
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_firewall" "my_firewall" {
  name    = "my-firewall"
  network = google_compute_network.my_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = google_compute_network.my_network.self_link
    subnetwork = google_compute_subnetwork.my_subnetwork.self_link

    access_config {
      // External IP
    }
  }
}
