resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_compute_instance" "default" {
  name         = "vm-tf-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      //image = "debian-cloud/debian-9"
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  //metadata_startup_script = "${file("./startup.ign")}"
  metadata_startup_script = <<EOH
#!/bin/bash
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
	jq

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

git clone https://github.com/dodopontocom/odroid-tensorflow.git
PROJECT=~/odroid-tensorflow
TB_TOKEN=<TELEGRAM_TOKEN>
echo $TB_TOKEN > $PROJECT/.token
cd $PROJECT
sudo docker build -t tensorflow . && sudo bash ./tb-produto.sh
  EOH

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