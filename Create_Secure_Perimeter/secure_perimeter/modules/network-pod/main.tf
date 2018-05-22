################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

provider "kubernetes" {
   config_path = "${var.cluster_config_path}"
   version = "~> 1.1"
}


resource "null_resource" "create_pvc" {
  provisioner "local-exec" {
        command = "kubectl --kubeconfig '${var.cluster_config_path}' apply -f ${path.module}/pvc.yaml"
     }
}

resource "null_resource" "create_pod" {
  provisioner "local-exec" {
        command = "kubectl --kubeconfig '${var.cluster_config_path}' create -f ${path.module}/network-pod.yaml"
     }
}



#Copy in the ssh key file and the config.json file

resource "null_resource" "copy_files_to_network-pod" {
   depends_on = ["null_resource.create_pod"]

   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp  ${path.root}/keys network-pod:/opt/secure-perimeter/"
     }
   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp  ${path.root}/state.json network-pod:/opt/secure-perimeter/state.json"
     }
   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp ${path.root}/config.json network-pod:/opt/secure-perimeter/config.json"
     }
   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp ${path.root}/rules.conf network-pod:/opt/secure-perimeter/rules.conf"
     }

}
