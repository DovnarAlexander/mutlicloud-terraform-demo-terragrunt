provider "google" {
  version = "~> 3.21"
  region  = "europe-west3"
  project = "mindful-genius-276909"
}


data "google_compute_zones" "available" {
  region = "europe-west3"
  status = "UP"
}

resource "google_compute_network" "network" {
  name                    = "deployment-instance"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  project                 = "mindful-genius-276909"
  description             = "deployment-instance"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "deployment-instance"
  ip_cidr_range = "192.168.100.0/24"
  region        = "europe-west3"
  network       = google_compute_network.network.self_link
}

resource "google_compute_instance" "vm" {
  name         = "deployment-instance"
  machine_type = "n1-standard-4"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  network_interface {
    network    = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      // Ephemeral IP
    }
  }
  metadata_startup_script =  <<EOT
    apt-get install unzip wget -y
    cd /usr/local/bin
    wget https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
    unzip terraform_0.12.25_linux_amd64.zip
    terraform_0.12.25_linux_amd64.zip
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.18/terragrunt_linux_amd64
    mv terragrunt_linux_amd64 terragrunt
    chmod +x terragrunt terraform
  EOT
  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1odv2yBWkJ6LW6+wQ14NCbPZ+SVqo8OUo+6T91aeHCIKz/r9D3e2s2kj59/acSnMkvhjwMTQv6eLVFBzsOaexS9UVzal4YC88kMGr1D39weesOeGG8h5rAW0WREKXpcyJrdYjZLEmLl7+77Y1EVn3daAILgmpvbaAS92Bado9f31x5yK/eRLxi8tgDW8W7rddw7Mb7EMK+wuQt5ECKlM/CWQK7yumjVAPk9LfDH50Z90nxatyNcdnO32xom018fsZ6nBMdOgqMtlbUDCxisoBR+8J+qjxZ2flAZS307AhQxthMZ2ooRfhEPR5XnmXLEGXX/6Etfm9iImm9fik+4Nb"
  }
}

resource "google_compute_firewall" "vm" {
  name    = "deployment-instance"
  network = google_compute_network.network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "endpoint" {
  value = google_compute_instance.vm.network_interface.0.access_config.0.nat_ip
}