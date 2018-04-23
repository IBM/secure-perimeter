################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

data "external" "network_gateway" {
  program = ["python", "${path.module}/network-gateway.py"]

  query = {
    gateway_name_id = "${var.gateway_name_id}"
    ims_user_id = "${var.ims_user_id}"
    ims_token = "${var.ims_token}"
  }
}

output "name" {
  value = "${data.external.network_gateway.result["name"]}"
}

output "id" {
  value = "${data.external.network_gateway.result["id"]}"
}

output "private_vlan_id" {
  value = "${data.external.network_gateway.result["private_vlan_id"]}"
}

output "private_vlan_number" {
  value = "${data.external.network_gateway.result["private_vlan_number"]}"
}

output "private_vlan_router" {
  value = "${data.external.network_gateway.result["private_vlan_router"]}"
}

output "public_vlan_id" {
  value = "${data.external.network_gateway.result["public_vlan_id"]}"
}

output "public_vlan_number" {
  value = "${data.external.network_gateway.result["public_vlan_number"]}"
}

output "public_vlan_router" {
  value = "${data.external.network_gateway.result["public_vlan_router"]}"
}

output "datacenter" {
  value = "${data.external.network_gateway.result["datacenter"]}"
}
