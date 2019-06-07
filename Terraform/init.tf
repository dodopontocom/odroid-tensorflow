resource resource "google_compute_instance" {

  provisioner "file" {
    source      = "./_scripts/init.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
   inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
  }
  
}
