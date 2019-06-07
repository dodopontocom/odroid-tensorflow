resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_compute_instance" "default" {
  name         = "odroid-tf-tf-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  tags         = ["externalssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }  
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral
    }
  }

 provisioner "file" {
    connection {
      type    = "ssh"
      user    = "root"
      timeout = "120s"
      host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
    }

    source      = "../_scripts/deploy-gcp.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    connection {
      type    = "ssh"
      user    = "root"
      timeout = "120s"
      host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
    }

    inline = [
      "sudo chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }

  depends_on = ["google_compute_firewall.gh-9564-firewall-externalssh"]
}

resource "google_compute_firewall" "gh-9564-firewall-externalssh" {
  name    = "gh-9564-firewall-externalssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalss"]
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

