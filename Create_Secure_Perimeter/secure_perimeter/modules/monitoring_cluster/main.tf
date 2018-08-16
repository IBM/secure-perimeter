################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

resource "ibm_container_cluster" "monitoring_cluster" {
  name         = "${var.cluster_name}"
  datacenter   = "${var.datacenter}"
  org_guid     = "${var.org_guid}"
  space_guid   = "${var.space_guid}"
  hardware     = "${var.hardware}"
  account_guid = "${var.account_guid}"
  machine_type = "${var.machine_type}"
  public_vlan_id = "${var.sps_public_vlan_id}"
  private_vlan_id = "${var.sps_private_vlan_id}"
  no_subnet    = true
  default_pool_size = 1
  tags = ["${var.file_id}","${var.gateway_notes}"]

}


data "ibm_container_cluster_config" "monitor_cluster_config" {
  cluster_name_id = "${ibm_container_cluster.monitoring_cluster.name}"
  org_guid        = "${var.org_guid}"
  space_guid      = "${var.space_guid}"
  account_guid    = "${var.account_guid}"
}

output "monitoring_cluster_name" {
  value = "${ibm_container_cluster.monitoring_cluster.name}"
}
