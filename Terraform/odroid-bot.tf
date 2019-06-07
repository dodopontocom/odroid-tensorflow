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
  
  network_interface {
    network = "default"
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
}

