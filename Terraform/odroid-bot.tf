resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_compute_instance" "default" {
  name         = "odroid-tf-tf-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }  
  }
  metadata = {
   ssh-keys = "thaizita11:${file("~/.ssh/pv.pub")}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
  
  provisioner "file" {
    source      = "../_scripts/deploy-gcp.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
   inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh"
    ]
   connection {
    type = "ssh"
    user = "root"
    password = ""
    host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
   }
  }

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

