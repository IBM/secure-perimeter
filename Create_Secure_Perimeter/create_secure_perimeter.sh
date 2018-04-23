#!/bin/bash

################################################################
# Module to create a secure perimeter
#
# ©Copyright IBM Corporation 2018.
# 
# LICENSE:Eclipse Public License, Version 2.0 - https://opensource.org/licenses/EPL-2.0
#
################################################################


cd secure_perimeter
# Remove these files as they may have been copied in during previous eployment - 
# They cannot be deployed in first stage of deploying secure perimeter
rm -f ./modules/monitoring_cluster/network_pod.tf
rm -f ./modules/monitoring_cluster/health_pod.tf

terraform init
terraform apply


#wait for monitoring cluster to come up

cp ../health_pod.tf ./modules/monitoring_cluster
terraform init
terraform apply  -target=module.monitoring_cluster.module.health-pod -auto-approve

cp ../network_pod.tf ./modules/monitoring_cluster
terraform init
terraform apply  -target=module.monitoring_cluster.module.network-pod -auto-approve


