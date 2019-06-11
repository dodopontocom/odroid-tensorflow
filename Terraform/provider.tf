provider "google" {
  credentials = "${file("~/account.json")}"
  project     = "odroid-tensorflow-243011"
  region      = "us-central1"

  /*provisioner "file" {
      source = "../account.json"
      destination = "/tmp/account.json"
  }*/
 
}
