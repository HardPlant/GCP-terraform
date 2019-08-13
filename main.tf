resource "google_compute_network" "securenetwork" {
  name = "securenetwork"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "securenetwork" {
  name = "subnet"
  network = "securenetwork"
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_firewall" "allow-rdp" {
  name = "allow-rdp"
  network = "default"
  allow {
      protocol = "tcp"
      ports    = ["3389"]
  }
}

resource "google_compute_instance" "vm-securehost" {
  name = "vm-securehost"
  machine_type = "n1-standard-1"
  boot_disk {
      initialize_params {
       image = "windows-2016"
      }
  }
  network_interface {
      network = "securenetwork"
  }
}

resource "google_compute_instance" "vm-bastionhost" {
  name = "vm-bastionhost"
  machine_type = "n1-standard-1"
  boot_disk {
      initialize_params {
          image = "windows-2016"
      }
  }
  network_interface {
      network = "securenetwork"
  }

  network_interface {
      network = "default"
  }
  provisioner "local-exec" {
      command = "gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone us-central1-a"
  }
}