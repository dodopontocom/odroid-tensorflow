provider "google" {
  credentials = "${file("~/account.json")}"
  project     = "odroid-tensorflow"
  region      = "us-central1"
}
