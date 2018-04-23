# IBM Cloud Secure Perimeter Segment

An IBM Cloud provider template to provision a secure Perimeter Segment - which consists of a public vlan and a private vlan.
This template depends on the previous creation of a Seure Perimeter. This tempalte will also apply rules to the Secure Perimeter to enfore this Secure Segment.
The infrastructure used is [Terraform](https://www.terraform.io/). With this template, you can provision and manage infrastructure as a single unit. 


## Create a Secure Perimeter Segment with this template



Pre-requisites 


    IBM Cloud infrastructure VPN access for SL account
    IBM Cloud CLI – Getting Started with IBM Cloud CLI
    kubectl – Setting up the CLI
    Container Registry with namespace configured – Setting up a Namespace
    Git – Getting Started – Installing Git
    terraform – Install Terraform
    ibm-cloud-provider  – Install ibm-cloud-provider
    python Version 2.7.10 – Install Python  with the following modules installed
        pyOpenSSL==17.5.0  -> pip install pyOpenSSL==17.5.0
        requests==2.18.4  -> pip install requests==2.18.4
        SoftLayer==5.4.2 4  -> pip install SoftLayer==5.4.2



    bx login –a api..bluemix.net -u username@domain.com --apikey 
    bx cr login

   
    cd secure-perimeter/Create_Secure_Perimeter_Segment
    terraform workspace new SPS1
    vi variables.tf
    
Fill in default values for 

      •	bluemix_api_key
      •	org
      •	space
      •	gateway_name_id
      •	region
      •	vlan_subnet_size
      •	monitoring_cluster_name_id
      
and save the file

    terraform init
    terraform apply

    Type yes and press Enter


### Variables


|Variable Name|Description|Default Value|
|-------------|-----------|-------------|
|bluemix_api_key|Your IBM Cloud API key. You can get the value by running `bx iam api-key-create <key name>`.||
|datacenter| The data center for the cluster, You can get the list with by running `bluemix cs locations`. |dal12|
|org| Your IBM Cloud org name.||
|region| The [IBM Cloud region](https://console.bluemix.net/docs/containers/cs_regions.html#regions-and-locations) where you want to deploy your secure-perimeter. |us-south|
|space| Your IBM Cloud space name.|dev|
|gateway_name_id| name or id of gateway in the seure perimeter|
|monitoring_cluster_name_id| name or id of monitoring cluster in Secure Perimeter|

