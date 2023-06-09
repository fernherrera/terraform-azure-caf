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
| [azurerm_monitor_autoscale_setting.mas](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Specifies whether automatic scaling is enabled for the target resource. Defaults to true. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the AutoScale Setting. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_notification"></a> [notification](#input\_notification) | (Optional) Specifies a notification block. | `map` | `{}` | no |
| <a name="input_profiles"></a> [profiles](#input\_profiles) | (Required) Specifies one or more (up to 20) profile blocks. | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in the AutoScale Setting should be created. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | (Required) Specifies the resource ID of the resource that the autoscale setting should be added to. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the AutoScale Setting. |
<!-- END_TF_DOCS -->