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



resource "kubernetes_pod" "network-pod" {
  metadata {
    name = "network-pod"
    namespace = "sp-monitoring"

    labels {
      app = "network-pod"
    }
  }

  spec {
    container {
      image = "registry.ng.bluemix.net/secure-perimeter/secure-perimeter:0.0.18"
      name  = "network-pod"
      volume_mount {
        name = "network-vol"
        mount_path = "/opt/secure-perimeter"
      }
    }
    image_pull_secrets = [
        {
          name = "bmx-container-registry"
        }
      ]
    volume {
      name = "network-vol"
      persistent_volume_claim {
        claim_name = "network-pvc"
    }
      
    }
  }
}



#Copy in the ssh key file and the config.json file

resource "null_resource" "copy_files_to_network-pod" {
   depends_on = ["kubernetes_pod.network-pod"] 

   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp  ${path.root}/keys sp-monitoring/network-pod:/opt/secure-perimeter/"
     }
   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp  ${path.root}/state.json sp-monitoring/network-pod:/opt/secure-perimeter/state.json"
     }
   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp ${path.root}/config.json sp-monitoring/network-pod:/opt/secure-perimeter/config.json" 
     }
   provisioner "local-exec" {
        command = "kubectl  --kubeconfig=${var.cluster_config_path} cp ${path.root}/rules.conf sp-monitoring/network-pod:/opt/secure-perimeter/rules.conf"
     }

}


