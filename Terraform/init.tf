resource resource "google_compute_instance" {

  provisioner "remote-exec" {
    inline = [
      "python --version",
      "git --version",
    ]
  }
  
}
