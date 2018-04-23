################################################################
# Module to create a health-pod
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

module "health-pod" {
  source = "../health-pod"
  slusername      = "${var.slusername}"
  slapikey        = "${var.slapikey}"
  sps_public_vlan_id = "${var.sps_public_vlan_id}"
  sps_private_vlan_id = "${var.sps_private_vlan_id}"
  org_guid        = "${var.org_guid}"
  space_guid      = "${var.space_guid}"
  account_guid    = "${var.account_guid}"
  cluster_config_path = "${data.ibm_container_cluster_config.monitor_cluster_config.config_file_path}"
}
