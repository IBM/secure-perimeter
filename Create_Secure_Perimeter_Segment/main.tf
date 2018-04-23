################################################################
# Module to create Secure Perimeter Segment
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

terraform {
  required_version = ">= 0.11.0"
}

provider "external" {
   version = "~> 1.0"
}
provider "null" {
   version = "~> 1.0"
}
provider "random" {
   version = "~> 1.2"
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

module "ims_credentials" {
  source = "./modules/ims_credentials"
  iam_apikey = "${var.bluemix_api_key}"
}

module "sl_credentials" {
  source = "./modules/sl_credentials"
  ims_user_id = "${module.ims_credentials.user_id}"
  ims_token = "${module.ims_credentials.token}"
}

module "network_gateway" {
  source = "./modules/network_gateway"
  gateway_name_id = "${var.gateway_name_id}"
  ims_user_id = "${module.ims_credentials.user_id}"
  ims_token = "${module.ims_credentials.token}"
}

provider "ibm" {
  bluemix_api_key = "${var.bluemix_api_key}"
  softlayer_username = "${module.sl_credentials.username}"
  softlayer_api_key = "${module.sl_credentials.apikey}"
  region = "${var.region}"
}

resource "random_id" "name" {
  byte_length = 4
}

resource "ibm_network_vlan" "sps_public_vlan" {
   name = "sps-pub-${random_id.name.hex}"
   datacenter = "${module.network_gateway.datacenter}"
   type = "PUBLIC"
   subnet_size = "${var.vlan_subnet_size}"
   router_hostname = "${module.network_gateway.public_vlan_router}"
}

resource "ibm_network_gateway_vlan_association" "public_vlan_assoc" {
  depends_on = ["ibm_network_vlan.sps_public_vlan"]
  gateway_id      = "${module.network_gateway.id}"
  network_vlan_id = "${ibm_network_vlan.sps_public_vlan.id}"
  bypass = false
}

resource "null_resource" "sleep_for_routing_60_secs" {
  depends_on = ["ibm_network_vlan.sps_public_vlan"]
  provisioner "local-exec" {
    command = "sleep 60"
  }

}


resource "ibm_network_vlan" "sps_private_vlan" {
  depends_on = ["ibm_network_vlan.sps_public_vlan", "null_resource.sleep_for_routing_60_secs" ]
  name = "sps-priv-${random_id.name.hex}"
  datacenter = "${module.network_gateway.datacenter}"
  type = "PRIVATE"
  subnet_size = "${var.vlan_subnet_size}"
  router_hostname = "${module.network_gateway.private_vlan_router}"
}

  resource "ibm_network_gateway_vlan_association" "private_vlan_assoc" {
  depends_on = ["ibm_network_vlan.sps_private_vlan"]
  gateway_id      = "${module.network_gateway.id}"
  network_vlan_id = "${ibm_network_vlan.sps_private_vlan.id}"
  bypass = false
}


data "ibm_network_vlan" "public_vlan" {
    name = "${ibm_network_vlan.sps_public_vlan.name}"
}

data "ibm_network_vlan" "private_vlan" {
    name = "${ibm_network_vlan.sps_private_vlan.name}"
}

data "ibm_container_cluster_config" "kube_config" {
  org_guid        = "${data.ibm_org.org.id}"
  space_guid      = "${data.ibm_space.space.id}"
  account_guid    = "${data.ibm_account.account.id}"
  cluster_name_id = "monitoring_cluster-${element(split("-", module.network_gateway.name), 2)}"
}




resource "null_resource" "copy-config-from-pod" {
  depends_on = ["ibm_network_gateway_vlan_association.private_vlan_assoc", "ibm_network_gateway_vlan_association.public_vlan_assoc"]

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${data.ibm_container_cluster_config.kube_config.config_file_path} cp sp-monitoring/network-pod:/opt/secure-perimeter/config.json ${path.root}/config.json"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --kubeconfig=${data.ibm_container_cluster_config.kube_config.config_file_path} cp sp-monitoring/network-pod:/opt/secure-perimeter/config.json ${path.root}/config.json"
  }
}

resource "null_resource" "configure_private_vlan" {
  depends_on = ["null_resource.copy-config-from-pod"]

  provisioner "local-exec" {
    command = "python ${path.root}/configure_vyatta.py --action add-vlan -n ${ibm_network_vlan.sps_private_vlan.vlan_number}  -i ${ibm_network_vlan.sps_private_vlan.id} -t private"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "python ${path.root}/configure_vyatta.py --action remove-vlan -i ${ibm_network_vlan.sps_private_vlan.id} -n ${ibm_network_vlan.sps_public_vlan.vlan_number} -t private"
  }
}

resource "null_resource" "configure_public_vlan" {
  depends_on = ["null_resource.configure_private_vlan"]

  provisioner "local-exec" {
    command = "python ${path.root}/configure_vyatta.py --action add-vlan -n ${ibm_network_vlan.sps_public_vlan.vlan_number}  -i ${ibm_network_vlan.sps_public_vlan.id} -t public"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "python ${path.root}/configure_vyatta.py --action remove-vlan -i ${ibm_network_vlan.sps_private_vlan.id} -n ${ibm_network_vlan.sps_public_vlan.vlan_number} -t public"
  }
}

resource "null_resource" "copy-config-to-pod" {
  depends_on = ["null_resource.configure_public_vlan"]

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${data.ibm_container_cluster_config.kube_config.config_file_path} cp ${path.root}/config.json sp-monitoring/network-pod:/opt/secure-perimeter/config.json"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl --kubeconfig=${data.ibm_container_cluster_config.kube_config.config_file_path} cp ${path.root}/config.json sp-monitoring/network-pod:/opt/secure-perimeter/config.json"
  }
}

resource "null_resource" "apply_config" {
  depends_on = ["null_resource.copy-config-to-pod"]

  provisioner "local-exec" {
    command = "kubectl exec --kubeconfig=${data.ibm_container_cluster_config.kube_config.config_file_path} -n sp-monitoring network-pod python config-secure-perimeter.py"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl exec --kubeconfig=${data.ibm_container_cluster_config.kube_config.config_file_path} -n sp-monitoring network-pod python config-secure-perimeter.py"
  }
}
