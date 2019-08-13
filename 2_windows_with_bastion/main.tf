resource "google_compute_network" "securenetwork" {
  name = "securenetwork"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name = "subnet"
  network = "${google_compute_network.securenetwork.name}"
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_firewall" "allow-rdp" {
  name = "allow-rdp"
  network = "default"
  allow {
      protocol = "tcp"
      ports    = ["3389"]
  }
  source_tags = ["rdp"]
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
      subnetwork = "default"
  }
  network_interface {
      network = "${google_compute_network.securenetwork.name}"
      subnetwork = "${google_compute_subnetwork.subnet.name}"
  }
  tags = ["rdp"]
  provisioner "local-exec" {
      command = "gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone us-central1-a"
  }
}

resource "google_compute_address" "bastion-address" {
  name = "bastion-address"
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
      subnetwork = "default"
  }
  network_interface {
      network = "${google_compute_network.securenetwork.name}"
      subnetwork = "${google_compute_subnetwork.subnet.name}"
      access_config {
          nat_ip = "${google_compute_address.bastion-address.address}"
      }
  }
  tags = ["rdp"]

  provisioner "local-exec" {
      command = "gcloud compute reset-windows-password vm-bastionhost --user app_admin --zone us-central1-a"
  }
}