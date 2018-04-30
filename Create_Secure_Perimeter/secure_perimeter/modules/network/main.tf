################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################
##############################################################################
# Require terraform 0.11.0 or greater
##############################################################################
terraform {
  required_version = ">= 0.11.0"
}
##############################################################################
# IBM Network VLAN 
##############################################################################

resource "null_resource" "generate_ssh_key" {

    provisioner "local-exec" {
        command = "mkdir -p ${path.root}/keys"
        interpreter = ["/bin/bash", "-c"]
     }
     provisioner "local-exec" {
        command = "echo -e  'y'|ssh-keygen -q -t rsa -N '' -C vyatta@secureperimeter.com -f ${path.root}/keys/id_rsa"
        interpreter = ["/bin/bash", "-c"]
     }
     provisioner "local-exec" {
        command = "cp -r ${path.root}/keys ${path.root}/keys_${var.random_id}"
        interpreter = ["/bin/bash", "-c"]
     }

}


#create terraform ssh key to pass to vyatta
resource "ibm_compute_ssh_key" "tf_public_key" {
   depends_on = ["null_resource.generate_ssh_key"]
   label = "tf_public_key_${var.random_id}"
   notes = "tf_public_key_${var.random_id}"
   public_key = "${file("${path.root}/keys/id_rsa.pub")}"
}


resource "ibm_network_vlan" "sps_public_vlan" {
   depends_on = ["null_resource.pull_image"]
   name = "pub-neb1-${var.random_id}"
   datacenter = "${var.datacenter}"
   type = "PUBLIC"
   subnet_size = "${var.sps_subnet_size}"
   router_hostname = "${var.f_router_hostname}"
}

data "ibm_network_vlan" "sps_public_vlan" {
    name = "${ibm_network_vlan.sps_public_vlan.name}"
}

resource "ibm_network_vlan" "sps_private_vlan" {
   depends_on = ["ibm_network_vlan.sps_public_vlan"]
   name = "prv-neb1-${var.random_id}"
   datacenter = "${var.datacenter}"
   type = "PRIVATE"
   subnet_size = "${var.sps_subnet_size}"
   router_hostname = "${var.b_router_hostname}"
}

data "ibm_network_vlan" "sps_private_vlan" {
    name = "${ibm_network_vlan.sps_private_vlan.name}"
}


resource "ibm_network_gateway" "gateway" {
  name = "sp-gateway-${var.random_id}"
  depends_on = ["ibm_network_vlan.sps_private_vlan","ibm_network_vlan.sps_public_vlan","ibm_compute_ssh_key.tf_public_key"]
  ssh_key_ids = ["${ibm_compute_ssh_key.tf_public_key.id}"]

  members {
    hostname             = "sp-vyatta-1-${var.random_id}"
    domain               = "secureperimeter.ibm.com"
    datacenter           = "${var.datacenter}"
    network_speed        = 100
    tcp_monitoring       = true
    tags                 = ["gateway"]
    notes                = "secure-perimeter"
    process_key_name     = "INTEL_SINGLE_XEON_1270_3_50"
    os_key_name          = "OS_VYATTA_5600_5_X_UP_TO_1GBPS_SUBSCRIPTION_EDITION_64_BIT"
    public_vlan_id       = "${data.ibm_network_vlan.sps_public_vlan.id}"
    private_vlan_id      = "${data.ibm_network_vlan.sps_private_vlan.id}"
    disk_key_names       = ["HARD_DRIVE_2_00TB_SATA_II"]
    public_bandwidth     = 20000
    memory               = 8
    ipv6_enabled         = true
    ssh_key_ids          = ["${ibm_compute_ssh_key.tf_public_key.id}"] 
  }

  members {
    hostname             = "sp-vyatta-2-${var.random_id}"
    domain               = "secureperimeter.ibm.com"
    datacenter           = "${var.datacenter}"
    network_speed        = 100
    tcp_monitoring       = true
    tags                 = ["gateway"]
    notes                = "secure-perimeter"
    process_key_name     = "INTEL_SINGLE_XEON_1270_3_50"
    os_key_name          = "OS_VYATTA_5600_5_X_UP_TO_1GBPS_SUBSCRIPTION_EDITION_64_BIT"
    public_vlan_id       = "${data.ibm_network_vlan.sps_public_vlan.id}"
    private_vlan_id      = "${data.ibm_network_vlan.sps_private_vlan.id}"
    disk_key_names       = ["HARD_DRIVE_2_00TB_SATA_II"]
    public_bandwidth     = 20000
    memory               = 8
    ipv6_enabled         = true
    ssh_key_ids          = ["${ibm_compute_ssh_key.tf_public_key.id}"] 
  }
}



# Route the 2 associated vlans to the vyatta - This code can go once new version of cloud provider available

resource "null_resource" "route_vlans" {
  depends_on = ["ibm_network_gateway.gateway"]
  provisioner "local-exec" {
    command = "curl --user ${var.slusername}:${var.slapikey}  -sk https://api.softlayer.com/rest/v3/SoftLayer_Network_Gateway/${ibm_network_gateway.gateway.id}/unbypassAllVlans" 

  }
}

resource "null_resource" "configure_vyatta_file" {
   depends_on = ["ibm_network_gateway.gateway", "null_resource.route_vlans"]

   # Add gateway details 
   provisioner "local-exec" {
     command = "python ${path.module}/configure_vyatta.py  --action add-sp -u ${var.slusername} -k ${var.slapikey} -a ${lookup(ibm_network_gateway.gateway.members[0],"private_ipv4_address")} -b ${lookup(ibm_network_gateway.gateway.members[0],"public_ipv4_address")}  -c ${lookup(ibm_network_gateway.gateway.members[1],"private_ipv4_address")} -d ${lookup(ibm_network_gateway.gateway.members[1],"public_ipv4_address")}  -v ${ibm_network_gateway.gateway.id} -r ${var.region} -gv ${ibm_network_gateway.gateway.public_ipv4_address}"
   }


   # Add public vlan info
   provisioner "local-exec" {
     command = "python ${path.module}/configure_vyatta.py --action add-vlan -n ${ibm_network_vlan.sps_public_vlan.vlan_number}  -i ${ibm_network_vlan.sps_public_vlan.id} -t public"
   }


   # Add private vlan info
   provisioner "local-exec" {
     command = "python ${path.module}/configure_vyatta.py --action add-vlan -n ${ibm_network_vlan.sps_private_vlan.vlan_number}  -i ${ibm_network_vlan.sps_private_vlan.id} -t private"
   }
}







##############################################################################
# Outputs
##############################################################################

output "gateway_name" {
  value = "${ibm_network_gateway.gateway.name}"
}
output "gateway_id" {
  value = "${ibm_network_gateway.gateway.id}"
}
output "sps_public_vlan_id" {
  value = "${ibm_network_vlan.sps_public_vlan.id}"
}
output "sps_private_vlan_id" {
  value = "${ibm_network_vlan.sps_private_vlan.id}"
}
output "sps_public_vlan_num" {
  value = "${ibm_network_vlan.sps_public_vlan.vlan_number}"
}
output "sps_private_vlan_num" {
  value = "${ibm_network_vlan.sps_private_vlan.vlan_number}"
}
output "sps_public_vlan_name" {
  value = "${ibm_network_vlan.sps_public_vlan.name}"
}
output "sps_private_vlan_name" {
  value = "${ibm_network_vlan.sps_private_vlan.name}"
}
output "sps_primary_gateway_ip" {
  value = "${lookup(ibm_network_gateway.gateway.members[0],"public_ipv4_address")}"
}
output "sps_secondary_gateway_ip" {
  value = "${lookup(ibm_network_gateway.gateway.members[1],"public_ipv4_address")}"
}
output "gateway_notes" {
  value = "${lookup(ibm_network_gateway.gateway.members[0],"notes")}"
}
output "file_id" {
  value = "${null_resource.configure_vyatta_file.id}"
}
