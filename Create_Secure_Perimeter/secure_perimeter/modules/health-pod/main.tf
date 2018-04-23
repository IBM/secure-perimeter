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


resource "kubernetes_namespace" "monitoring_namespace" {
  metadata {
    name = "sp-monitoring"
  }
}

# TODO: can remove kube secret once image is available publicly
resource "kubernetes_secret" "bmx_container_registry" {
  depends_on = ["kubernetes_namespace.monitoring_namespace"]

  metadata {
    name = "bmx-container-registry"
    namespace = "sp-monitoring"
  }

  data {
    ".dockercfg" = "${file("${path.module}/registry-config.json")}"
  }

  type = "kubernetes.io/dockercfg"
}

resource "kubernetes_replication_controller" "health_pod" {
  depends_on = ["kubernetes_secret.bmx_container_registry"]

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
        # TODO: update image location - <registry>/secure-perimeter/sps-exposure-monitoring:latest
        image = "registry.ng.bluemix.net/secure-perimeter/health_monitoring:1.0"
        name  = "health-pod"
        args  = [
          "/usr/local/bin/python",
          "/check_sp.py",
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
          name = "bmx-container-registry"
        }
      ]
    }
  }
}
