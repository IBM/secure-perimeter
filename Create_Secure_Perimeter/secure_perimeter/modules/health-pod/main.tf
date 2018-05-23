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

resource "kubernetes_replication_controller" "health_pod" {
  metadata {
    name = "health-pod"

    labels {
      app = "health-pod"
    }
  }

  spec {
    selector {
      app = "health-pod"
    }
    template {
      container {
        image = "registry.bluemix.net/ibm/ibmcloud-secure-perimeter-health:1.0.0"
        name  = "health-pod"
        args  = [
          "/usr/local/bin/python",
          "/run.py",
          "--scan",
          "private",
          "--exclude-vlan-ids",
          "${var.sps_public_vlan_id}",
          "${var.sps_private_vlan_id}",
          "--poll-interval",
          "1800",
          "--allowed-public-ports",
          "80",
          "443",
          "9000-9999"
        ]
        env {
          name = "SL_USER"
          value = "${var.slusername}"
        }
        env {
          name = "SL_APIKEY"
          value = "${var.slapikey}"
        }
      }
    }
  }
}
