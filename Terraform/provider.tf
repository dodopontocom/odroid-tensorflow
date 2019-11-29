provider "google" {
  credentials = "${file("~/account.json")}"
  project     = "gcp-my-labs"
  region      = "us-central1"
}
