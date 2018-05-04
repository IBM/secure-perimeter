variable "bluemix_api_key" {
  description = "Your IBM Cloud API key. You can get the value by running bx iam api-key-create <key name>."
}

variable "gateway_name_id" {
  description = "The name or ID of the gateway to deploy segment into"
}

variable "public_vlan_name" {
    description = "Public vlan name"
}
variable "private_vlan_name" {
    description = "Private vlan name"
}

variable "vlan_subnet_size" {
   description = "Vlan subnet size  8|16|32|64"
   default = 8
}

variable "org" {
  description = "Your IBM Cloud org name."
}

variable "space" {
  description = "Your IBM Cloud space name."
}

variable "region" {
  description = "The IBM Cloud region where you want to deploy your cluster for example us-south."
}
