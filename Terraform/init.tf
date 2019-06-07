resource resource "google_compute_instance" "default" {

  provisioner "remote-exec" {
    inline = [
      "python --version",
      "git --version",
    ]
  }
  
}
