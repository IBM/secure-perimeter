# SSH key template

An [IBM Cloud Schematics](https://console.bluemix.net/docs/services/schematics/index.html) template that creates an [IBM Cloud SSH Key](https://ibm-bluemix.github.io/tf-ibm-docs/v0.4.0/r/compute_ssh_key.html) (`ibm_compute_ssh_key`). This template creates am SSH key in the specified IBM Cloud account. This is not a module, it is a Terraform configuration that should be cloned or forked to be used.

Schematics uses [Terraform](https://www.terraform.io/) as the infrastructure as code engine. With this template, you can provision and manage infrastructure as a single unit.

See the [Terraform provider docs](https://ibm-bluemix.github.io/tf-ibm-docs/) for available resources for the IBM Cloud.

**This configuration template is written for IBM Cloud provider version `v0.4.0`**

## Create an environment with this template

Environments can be used to separate software components into development tiers (e.g. staging, QA, and production).

1. In IBM Cloud, go to the menu and select the [Schematics dashboard](https://console.bluemix.net/schematics).
2. In the left navigation menu, select **Templates** to access the template catalog.
3. Click **Create** on the SSH key template. You are taken to a configuration page where you can define metadata about your environment. 
4. Define values for your variables according to the following table. 

### Variables

|Variable Name|Description|Default Value|
|-------------|-----------|-------------|
|bxapikey|Your IBM Cloud API key. You can get the value by running `bx iam api-key-create <key name>`.||
|datacenter|The data center for the SSH key. You can run `bluemix cs locations` to see a list of all data centers in your region.||
|key_label|An identifying label to assign to the SSH key.||
|key_note|Notes to store with the SSH key. | |
|public_key|The public key contents for the SSH keypair. | |
|slapikey|Your IBM Cloud Infrastructure (SoftLayer) API key.| |
|slusername|Your IBM Cloud Infrastructure (SoftLayer) user name.||

### Next steps

After setting up your environment with this template, you can run **Plan** to preview how Schematics will deploy resources to your environment. When you are ready to deploy the cluster, run **Apply**.

## Using the Terraform binary on your local workstation
You will need to [set up up IBM Cloud provider credentials](#setting-up-provider-credentials) on your local machine. Then you will need the [Terraform binary](https://www.terraform.io/intro/getting-started/install.html) and the [IBM Cloud Provider Plugin](https://github.com/IBM-Bluemix/terraform/releases). Then follow the instructions at [https://ibm-bluemix.github.io/tf-ibm-docs/v0.4.0/#developing-locally](https://ibm-bluemix.github.io/tf-ibm-docs/v0.4.0/#developing-locally).

To run this project locally, complete the following steps:

- Supply the `datacenter`, `public_key`, `key_label`, and `key_note` variable values in `terraform.tfvars`, see https://www.terraform.io/intro/getting-started/variables.html#from-a-file for instructions.
  - Alternatively, these values can be supplied via the command line or environment variables, see https://www.terraform.io/intro/getting-started/variables.html.
- Specifically for `public_key` material, see [Generating a new SSH key and adding it to the ssh-agent](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)) so that your workstation will use the key.
- `terraform plan`: This command performs a dry run to show what infrastructure Terraform intends to create.
- `terraform apply`: This command creates actual infrastructure.
  - Infrastructure can be seen in IBM Cloud under the following URLs:
    - SSH keys: https://control.bluemix.net/devices/sshkeys
- `terraform destroy`: This command destroy all infrastructure that has been created.

### Available data centers
You can run `bluemix cs locations` to see a list of all data centers in your region.

### Running in multiple data centers
You can run `terraform plan -var 'datacenter=lon02' -state=lon02.tfstate` or whatever your preferred data center is (replace `lon02` for both arguments), and repeat for `terraform apply` with the same arguments.

## Setting up provider credentials
To set up the IBM Cloud provider to work with this example there are a few options for managing credentials safely. The preferred method is using environment variables. See the [Terraform variable documentation](https://www.terraform.io/intro/getting-started/variables.html) for other methods.

### Exporting environment variables using IBMid credentials
You'll need to export the following environment variables:

- `TF_VAR_bxapikey` - Your IBM Cloud API Key
- `TF_VAR_slusername` - Your IBM Cloud Infrastructure (SoftLayer) username
- `TF_VAR_slapikey` - Your IBM Cloud Infrastructure user name.

On OS X, you can enter the following commands into your terminal:

- `export TF_VAR_bxapikey=<value>`
- `export TF_VAR_slusername=<value>`
- `export TF_VAR_slapikey=<value>`

This is only temporary to your current terminal session. To make this permanent, add these export statements to your `~/.profile`, `~/.bashrc`, `~/.bash_profile` or preferred terminal configuration file. If you go this route without running `export ...` in your command prompt, you'll need to source your terminal configuration file from the command prompt like so: `source ~/.bashrc` (or your preferred config file).

## License
MIT; see [LICENSE](LICENSE) for details.
# network
