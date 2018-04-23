variable "bluemix_api_key" {
  description = "The IBM Cloud platform API key"
}

variable "docker_image" {
  description = "The path to the Bluechatter docker image"
  default = "registry.ng.bluemix.net/secure-perimeter/bluechatter_app:latest"
}

variable "kube_cluster_name_id" {
  description = "The name or ID of the kubernetes cluster to deploy the BlueChatter app into"
}

variable "compose_cluster_id" {
  description = "The Cluster ID of your Compose Enterprise deployment"
}

variable "expose_on_port" {
  description = "The port to access the BlueChatter app (must be in range 30000-32767)"
  default     = 30089
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
