################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

# ----------------------------------------------- #
# ----------- BlueChatter SP demo --------------- #
# ----------------------------------------------- #

provider "ibm" {
  bluemix_api_key = "${var.bluemix_api_key}"
}

data "ibm_org" "org" {
  org = "${var.org}"
}

data "ibm_space" "space" {
  org   = "${var.org}"
  space = "${var.space}"
}

data "ibm_account" "account" {
  org_guid = "${data.ibm_org.org.id}"
}

# get the kube config of the cluster to deploy app into
data "ibm_container_cluster_config" "kube_config" {
  org_guid        = "${data.ibm_org.org.id}"
  space_guid      = "${data.ibm_space.space.id}"
  account_guid    = "${data.ibm_account.account.id}"
  cluster_name_id = "${var.kube_cluster_name_id}"
}

data "ibm_container_cluster" "kube_cluster" {
  org_guid        = "${data.ibm_org.org.id}"
  space_guid      = "${data.ibm_space.space.id}"
  account_guid    = "${data.ibm_account.account.id}"
  cluster_name_id = "${var.kube_cluster_name_id}"
}

data "ibm_container_cluster_worker" "kube_worker" {
  org_guid        = "${data.ibm_org.org.id}"
  space_guid      = "${data.ibm_space.space.id}"
  account_guid    = "${data.ibm_account.account.id}"
  worker_id       = "${data.ibm_container_cluster.kube_cluster.workers.0}"
}

# create the Redis service on Compose
resource "ibm_service_instance" "compose_redis" {
  name       = "bluechatter-redis"
  space_guid = "${data.ibm_space.space.id}"
  service    = "compose-for-redis"
  plan       = "Enterprise"
  parameters = {
    cluster_id = "${var.compose_cluster_id}"
    db_version = "LATEST_PREFERRED"
  }
  tags       = ["cluster-service", "cluster-bind"]
  wait_time_minutes = 5
}

# create access credentials for the Redis service
resource "ibm_service_key" "compose_redis_creds" {
  name                  = "${ibm_service_instance.compose_redis.name}-creds"
  service_instance_guid = "${ibm_service_instance.compose_redis.id}"
}

data "ibm_service_instance" "compose_redis" {
  depends_on = ["ibm_service_key.compose_redis_creds"]
  name       = "${ibm_service_instance.compose_redis.name}"
  space_guid = "${data.ibm_space.space.id}"
}

provider "kubernetes" {
  config_path = "${data.ibm_container_cluster_config.kube_config.config_file_path}"
}

# deploy the BlueChatter app
resource "kubernetes_replication_controller" "bluechatter_pod" {
  metadata {
    name = "bluechatter"

    labels {
      bluechatter = "web"
    }
  }

  spec {
    selector {
      bluechatter = "web"
    }

    template {
      container {
        name = "web"
        image = "${var.docker_image}"
        port {
          container_port = 80
        }
        port {
          container_port = 8080
        }
        env {
          name = "SERVICE_URI"
          value = "${data.ibm_service_instance.compose_redis.service_keys.0.credentials.uri}"
        }
      }
    }
  }
}

# expose the BlueChatter app on
resource "kubernetes_service" "node_port" {
  depends_on = ["kubernetes_replication_controller.bluechatter_pod"]
  metadata {
    name = "web"

    labels {
      bluechatter = "web"
    }
  }
  spec {
    type = "NodePort"
    port {
      port = 80
      node_port = "${var.expose_on_port}"
    }
    selector {
      bluechatter = "web"
    }
  }
}

output "bluechatter_url" {
  value = "${data.ibm_container_cluster_worker.kube_worker.public_ip}:${var.expose_on_port}"
}
