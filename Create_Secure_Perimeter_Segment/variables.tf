variable "bluemix_api_key" {
  description = "Your IBM Cloud API key. You can get the value by running bx iam api-key-create <key name>."
  default = ""
}

variable "gateway_name_id" {
  description = "The name or ID of the gateway to deploy segment into"
  default = ""
}

variable "vlan_subnet_size" {
   description = "Vlan subnet size  8|16|32|64"
   default = 8
}

variable "org" {
  description = "Your IBM Cloud org name."
  default = ""
}

variable "space" {
  description = "Your IBM Cloud space name."
  default = ""
}

variable "region" {
  description = "The IBM Cloud region where you want to deploy your cluster for example us-south."
  default = ""
}
