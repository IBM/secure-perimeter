variable "sps_public_vlan_id" {
   type = "string"
   description = "VPCS Public Vlan ID"
}

variable "sps_private_vlan_id" {
   type = "string"
   description = "VPCS Private Vlan ID"
}
variable "slusername" {
  type = "string"
  description = "SoftLayer username"
}

variable "slapikey" {
  description = "SoftLayer api key"
}

variable "slemail" {
  description = "SoftLayer user email"
}

variable "cluster_config_path" {
   type = "string"
   description = "Cluster name config path"
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
