# Cloud Adoption Framework for Azure - Terraform module examples

The Cloud Adoption Framework for Azure - Terraform module can be used to deployed all components of CAF and compose those components together. It allows you to create complex architectures and composition relying on community contributions and proven patterns.

## Run the examples in this library

The current folder contains an example of module with the whole features set of the module, to run all the examples in the subfolders. You can leverage it the following way:

```bash
# Set working dir to the examples folder
cd /azure-caf/examples

# Login to Azure 
az login

# Set Azure subscription
az account set --subscription <subscription Id>

# Run Terraform example
terraform init
terraform plan -var-file <path to your variable file>
terraform apply -var-file <path to your variable file>
terraform destroy -var-file <path to your variable file>
```
