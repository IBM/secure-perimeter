# IBM Cloud Secure Perimeter 

An IBM Cloud provider template to provision a secure Perimeter  - which consists of a 2 member HA vyatta, a public vlan , a private vlan and a Kubernetes cluster with 1 worker node in IBM Cloud. The infrastructure used is [Terraform](https://www.terraform.io/). With this template, you can provision and manage infrastructure as a single unit. This template also deploys onto the kubernetes monitoring cluster,  a health pod for monitoring health of the perimeter,  and a network pod responsible for setting up the security on the vyatta to  maintain the secure perimeter.


## Create a Secure Perimeter with this template



Pre-requisistes 


    IBM Cloud infrastructure VPN access for SL account  
    
    
    IBM Cloud CLI  
    https://console.bluemix.net/docs/cli/reference/bluemix_cli/get_started.html#getting-started?cm_sp=dw-bluemix-_-dwblog-_-devcenter
    kubectl – https://console.bluemix.net/docs/containers/cs_cli_install.html#cs_cli_install?cm_sp=dw-bluemix-_-dwblog-_-devcenter
    
    Container Registry with namespace configured – Setting up a Namespace - https://console.bluemix.net/docs/services/Registry/registry_setup_cli_namespace.html#registry_setup_cli_namespace?cm_sp=dw-bluemix-_-dwblog-_-devcenter
    Git – Getting Started – https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
    Docker – Install Docker - https://docs.docker.com/install/
    terraform – Install Terraform - https://www.terraform.io/intro/getting-started/install.html
    ibm-cloud-provider  
       ---------------
       mkdir –p /home/terraform_providers/terraform-provider-ibm 
       cd /home/terraform_providers/terraform-provider-ibm 

       Depending on whether you are using MAC or Linux download the correct binary 
       LINUX:
       wget https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v0.8.0/linux_amd64.zip unzip linux_amd64.zip 
       MAC: 
       wget https://github.com/IBM-Cloud/terraform-provider-ibm/releases/download/v0.8.0/darwin_amd64.zip unzip darwin_amd64.zip
       vi $HOME/.terraformrc and add the following line 
           providers { ibm = "/home/terraform_providers/terraform-provider-ibm/terraform-provider-ibm" }

    python Version 2.7.10 – Install Python  with the following modules installed
        pyOpenSSL==17.5.0  -> pip install pyOpenSSL==17.5.0
        requests==2.18.4  -> pip install requests==2.18.4
        SoftLayer==5.4.2 4  -> pip install SoftLayer==5.4.2



    bx login –a api.<region>.bluemix.net -u username@domain.com --apikey 
    bx cr login

    mkdir –p $HOME/SecurePerimeter
    cd $HOME/SecurePerimeter
    git clone < TO BE ADDED>
    cd secure-perimeter/Create_Secure_Perimeter/secure_perimeter
    terraform workspace new SP1
    vi variables.tf
    Fill in default values for 
        •	bluemix_api_key
        •	org
        •	space
        •	f_router_hostname
        •	b_router_hostname
        •	region
        •	datacentre
    and save the file
    cd $HOME/SecurePerimeter/secure-perimeter/Create_Secure_Perimeter
    ./create_secure_perimeter.sh <unique name for this environment - example SP1>

    Type yes and press Enter


### Variables


|Variable Name|Description|Default Value|
|-------------|-----------|-------------|
|bluemix_api_key|Your IBM Cloud API key. You can get the value by running `bx iam api-key-create <key name>`.||
|datacenter| The data center for the cluster, You can get the list with by running `bluemix cs locations`. |dal12|
|org| Your IBM Cloud org name.||
|region| The [IBM Cloud region](https://console.bluemix.net/docs/containers/cs_regions.html#regions-and-locations) where you want to deploy your secure-perimeter. |us-south|
|space| Your IBM Cloud space name.|dev|
|f_router_hostname| Front router hostname on which to deploy secure perimeter|
|b_router_hostname| Back router hostname on which to deploy secure perimeter|
