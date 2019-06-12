resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_compute_instance" "default" {
  name         = "vm-tf-${random_id.instance_id.hex}"
  machine_type = "g1-small"
  zone         = "us-central1-a"
  
  boot_disk {
    initialize_params {
      //image = "debian-cloud/debian-9"
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  metadata_startup_script = "${file("../scripts/deploy-gcp-v2.sh")}"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
}

/*
resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}
*/
output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
