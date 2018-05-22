################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

##############################################################################
# IBM Cloud Provider
##############################################################################
# See the README for details on ways to supply these values
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

module "ims_credentials" {
  source = "./modules/ims_credentials"
  iam_apikey = "${var.bluemix_api_key}"
}

module "sl_credentials" {
  source = "./modules/sl_credentials"
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


module "network" {
    source = "./modules/network"
    datacenter = "${var.datacenter}"
    random_id = "${random_id.name.hex}"
    slusername = "${module.sl_credentials.username}"
    slapikey = "${module.sl_credentials.apikey}"
    sps_subnet_size = "${var.sps_subnet_size}"
    sps_public_vlan_name = "${var.public_vlan_name}"
    sps_private_vlan_name = "${var.private_vlan_name}"
    region = "${var.region}"
}


module "monitoring_cluster" {

    source = "./modules/monitoring_cluster"
    cluster_name = "${var.cluster_name}-${random_id.name.hex}"
    datacenter   = "${var.datacenter}"
    random_id    = "${random_id.name.hex}"
    org_guid     = "${data.ibm_org.org.id}"
    space_guid   = "${data.ibm_space.space.id}"
    slusername = "${module.sl_credentials.username}"
    slapikey = "${module.sl_credentials.apikey}"
    slemail  = "${module.sl_credentials.email}"
    account_guid = "${data.ibm_account.account.id}"
    machine_type = "${var.machine_type}"
    sps_public_vlan_id = "${module.network.sps_public_vlan_id}"
    sps_private_vlan_id = "${module.network.sps_private_vlan_id}"
    gateway_notes = "${module.network.gateway_notes}"
    num_workers = "${var.num_workers}"
    workers = "${var.workers}"
    file_id = "${module.network.file_id}"
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

output "monitoring_cluster_name" {
  value = "${var.cluster_name}-${random_id.name.hex}"
}
output "sps_public_vlan_id" {
  value = "${module.network.sps_public_vlan_id}"
}
output "sps_private_vlan_id" {
  value = "${module.network.sps_private_vlan_id}"
}
output "sps_public_vlan_name" {
  value = "${module.network.sps_public_vlan_name}"
}
output "sps_private_vlan_name" {
  value = "${module.network.sps_private_vlan_name}"
}
output "sps_public_vlan_num" {
  value = "${module.network.sps_public_vlan_num}"
}
output "sps_private_vlan_num" {
  value = "${module.network.sps_private_vlan_num}"
}
output "gateway_name" {
  value = "${module.network.gateway_name}"
}
output "gateway_id" {
  value = "${module.network.gateway_id}"
}
