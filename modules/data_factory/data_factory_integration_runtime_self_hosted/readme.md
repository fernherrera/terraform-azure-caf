# data_factory_integration_runtime_self_hosted

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
|data_factory_id |The ID of the Data Factory.||True|
|name| The name which should be used for this Data Factory. Changing this forces a new Data Factory Self-hosted Integration Runtime to be created.||True|
|resource_group_name |The name of the resource_group.||True|

## Outputs

| Name | Description |
|------|-------------|
|id|The ID of the Data Factory.|||
|auth_key_1|The primary integration runtime authentication key.|||
|auth_key_2|The secondary integration runtime authentication key.|||

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory_integration_runtime_self_hosted.dfirsh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create resource group and use it for all networking resources | `bool` | `false` | no |
| <a name="input_data_factory_id"></a> [data\_factory\_id](#input\_data\_factory\_id) | Changing this forces a new Data Factory Self-hosted Integration Runtime to be created. | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the API Management service instance | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Data Factory runtime. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Data Factory runtime. |
<!-- END_TF_DOCS -->