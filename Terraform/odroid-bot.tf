resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_compute_instance" "default" {
  name         = "odroid-tf-tf-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"
  
  connection {
    type        = "ssh"
    agent       = false
    user        = "${var.gce_ssh_user}"
    port        = "${var.gce_ssh_port}"
    timeout     = "5m"
    private_key = "${file("${var.gce_ssh_private_key_file}")}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }  
  }

  provisioner "file" {
    source      = "../_scripts/deploy-gcp.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
   inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
}

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

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

