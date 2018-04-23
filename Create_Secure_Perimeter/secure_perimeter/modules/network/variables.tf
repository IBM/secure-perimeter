variable "datacenter" {
   type = "string"
   description = "DataCenter name"
}

variable "slusername" {
   description = "SL username"
}

variable "slapikey" {
   description = "SL api key"
}

variable "sps_subnet_size" {
   description = "VPCS subnet size  8|16|32|64"
   default = 8
}

variable "random_id" {
   type = "string"
   description = "Random ID for naming resources"
}

variable "f_router_hostname" {
   type = "string"
   description = "Name of front router hostname to deploy secure perimeter"
}

variable "b_router_hostname" {
    type = "string"
    description = "Name of back router hostname to deploy secure perimeter"
}

variable "region" {
    description = "Region name - for example us-south, us-east etc"
}
   

