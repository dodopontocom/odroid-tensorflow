resource "random_id" "instance_id" {
  byte_length = 6
}

resource "google_container_cluster" "odroid-tensorflow" {
  name     = "odroid-tf-tf-${random_id.instance_id.hex}"
  location = "us-central1-a"

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""
  }
}

resource "google_container_node_pool" "odroid-tensorflow_preemptible_nodes" {
  name       = "odroid-tensorflow-node-pool"
  location   = "us-central1-a"
  cluster    = "${google_container_cluster.odroid-tensorflow.name}"
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
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

/*
Configure Service account key
*/
provider "kubernetes" {
  host = "${google_container_cluster.odroid-tensorflow.endpoint}"
  username = "${google_container_cluster.odroid-tensorflow.master_auth.0.username}"
  password = "${google_container_cluster.odroid-tensorflow.master_auth.0.password}"
  client_certificate = "${base64decode(google_container_cluster.odroid-tensorflow.master_auth.0.client_certificate)}"
  client_key = "${base64decode(google_container_cluster.odroid-tensorflow.master_auth.0.client_key)}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.odroid-tensorflow.master_auth.0.cluster_ca_certificate)}"
  }
  

// https://www.terraform.io/docs/providers/google/r/google_service_account_key.html
// https://cloud.google.com/kubernetes-engine/docs/tutorials/authenticating-to-cloud-platform
resource "kubernetes_secret" "odroid-tensorflow" {
  metadata {
    name = "service-account"
  }
  data = {
    key.json = "${base64decode(google_service_account_key.odroid-tensorflow.private_key)}"
  }
}
