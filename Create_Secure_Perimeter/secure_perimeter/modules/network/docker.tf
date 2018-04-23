################################################################
#
# docker container to set the interfaces for the new subnet to the vyatta so monitoring cluster can come up
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

provider "docker" {
    host = "unix:///var/run/docker.sock"
    version = "~> 0.1"
}
resource "null_resource" "pull_image" {

  provisioner "local-exec" {
    command = "docker pull registry.ng.bluemix.net/secure-perimeter/secure-perimeter:0.0.15"
  }

}

# Create a container
resource "docker_container" "set_interfaces" {
  depends_on = ["null_resource.configure_vyatta_file", "null_resource.pull_image"]
  image = "registry.ng.bluemix.net/secure-perimeter/secure-perimeter:0.0.15"
  name  = "network_container_${var.random_id}"
  command = ["python","config-secure-perimeter.py"]
  volumes {
    container_path = "/opt/secure-perimeter"
    host_path = "${path.root}"
    read_only = false
    }
}
