################################################################
#
# ©Copyright IBM Corporation 2018.
#
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################

variable "bluemix_api_key" {
  description = "Your IBM Cloud API key. You can get the value by running bx iam api-key-create <key name>."
  default = ""
}

variable "org" {
  description = "Your IBM Cloud org name."
  default = ""
}

variable "space" {
  description = "Your IBM Cloud space name."
  default = ""
}

variable "sps_subnet_size" {
  description = "VPCS Subnet Size 8|16|32|64"
  default = 8
}
variable "region" {
  description = "The IBM Cloud region where you want to deploy your cluster for example us-south."
  default = ""
}
variable "datacenter" {
  description = "The data center for the cluster, You can get the list with by running bluemix cs locations for example dal13."
  default = ""
}
variable "public_vlan_name" {
    description = "Public vlan name"
    default = ""
}
variable "private_vlan_name" {
    description = "Private vlan name"
    default = ""
}


variable "cluster_name" {
  default = "monitoring_cluster"
  description = "The base name for the cluster."
}
variable "hardware" {
  default = "dedicated"
}
variable "machine_type" {
  default = "u2c.2x4"
  description = "The CPU cores, memory, network, and speed. You can get a list for a given location by running bluemix cs machine-types <location>."
}
variable "isolation" {
  default = "dedicated"
}
variable "cores" {
  default = 1
  description = "The number of core processors in VM instance for tomcat"
}
variable "memory" {
  default = 1024
  description = "The memory in MB for VM instance for tomcat"
}
variable "disk_size" {
  default = 25
  description = "The disk_size in GB for VM instance for tomcat"
}
variable "num_workers" {
   description = "Number of workers"
   default = 1
}
