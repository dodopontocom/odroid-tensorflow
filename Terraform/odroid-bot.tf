resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_container_cluster" "odroid-tensorflow" {
  name     = "odroid-tf-tf-${random_id.instance_id.hex}"
  location = "us-central-a"

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "odroid-tensorflow_preemptible_nodes" {
  name       = "odroid-tensorflow-node-pool"
  location   = "us-central-a"
  cluster    = "${google_container_cluster.odroid-tensorflow.name}"
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata {
      disable-legacy-endpoints = "true"
    }

    // https://www.terraform.io/docs/providers/google/r/container_cluster.html#storage-ro
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

provisioner "file" {
  source      = "../_scripts/init.sh"
  destination = "/tmp/script.sh"
}
provisioner "remote-exec" {
  inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
}

