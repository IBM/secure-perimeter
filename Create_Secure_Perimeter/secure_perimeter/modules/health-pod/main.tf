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

module "registry_token" {
  source = "../modules/registry_token"
  file_path = "${path.module}/docker-registry.json"
  email = "${var.slemail}"
}

resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = "sp-monitoring"
  }
}

resource "kubernetes_secret" "regcred" {
  metadata {
    name = "regcred"
    namespace = "test-ns"
  }

  data {
    ".dockercfgjson" = "${file(module.registry_token.file_path)}"
  }

  type = "kubernetes.io/dockercfgjson"
}

resource "kubernetes_replication_controller" "health_pod" {
  depends_on = ["kubernetes_secret.regcred"]

  metadata {
    name = "health-pod"
    namespace = "sp-monitoring"

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
        image = "registry.ng.bluemix.net/ibm/ibmcloud-secure-perimeter-health:1.0.0"
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
      image_pull_secrets = [
        {
          name = "regcred"
        }
      ]
    }
  }
}
