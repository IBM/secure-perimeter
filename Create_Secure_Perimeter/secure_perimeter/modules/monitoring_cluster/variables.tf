variable "slusername" {
   description = "SL username"
}

variable "slapikey" {
   description = "SL api key"
}

variable "slemail" {
  description = "SL email"
}

variable "cluster_name" {
   type = "string"
   description = "Cluster name"
}
variable "random_id" {
   type = "string"
   description = "Random ID for naming resources"
}
variable "datacenter" {
   type = "string"
   description = "Datacenter name"
}

variable "machine_type" {
   type = "string"
   description = "Machine type"
}

variable "org_guid" {
   type = "string"
   description = "Org guid"
}

variable "space_guid" {
   type = "string"
   description = "Space guid"
}

variable "account_guid" {
   type = "string"
   description = "Account guid"
}

variable "sps_public_vlan_id" {
   type = "string"
   description = "VPCS Public Vlan ID"
}

variable "sps_private_vlan_id" {
   type = "string"
   description = "VPCS Private Vlan ID"
}

variable "gateway_notes" {
   type = "string"
   description = "Gateway Notes"
}

variable "file_id" {
   type = "string"
   description = "configure_vyatta_file id - needed as dependency beofre creating cluster"
}
variable "workers" {
   type = "list"
   description = "workers names"
}

variable "num_workers" {
   description = "Number of workers"
}
