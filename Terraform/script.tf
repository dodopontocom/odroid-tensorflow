resource "null_resource" "odroid-tensorflow" {
    depends_on = ["google_container_node_pool.odroid-tensorflow_preemptible_nodes"]
    //depends_on       = ["google_container_cluster.odroid-tensorflow"]
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