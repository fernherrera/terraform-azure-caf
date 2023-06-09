<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_subscription.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_subscription) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_tracing"></a> [allow\_tracing](#input\_allow\_tracing) | (Optional) Determines whether tracing can be enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_api_id"></a> [api\_id](#input\_api\_id) | (Optional) The ID of the API which should be assigned to this Subscription. | `any` | `null` | no |
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | (Required) The name of the API Management Service. | `string` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The Display Name for this API Management Product. | `string` | n/a | yes |
| <a name="input_primary_key"></a> [primary\_key](#input\_primary\_key) | (Optional) The primary subscription key to use for the subscription. | `any` | `null` | no |
| <a name="input_product_id"></a> [product\_id](#input\_product\_id) | (Optional) The ID of the Product which should be assigned to this Subscription. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the API Management Service should be exist. | `string` | n/a | yes |
| <a name="input_secondary_key"></a> [secondary\_key](#input\_secondary\_key) | (Optional) The secondary subscription key to use for the subscription. | `any` | `null` | no |
| <a name="input_state"></a> [state](#input\_state) | (Optional) The state of this Subscription. Possible values are active, cancelled, expired, rejected, submitted and suspended. Defaults to submitted. | `string` | `"submitted"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | (Optional) An Identifier which should used as the ID of this Subscription. If not specified a new Subscription ID will be generated. | `any` | `null` | no |
| <a name="input_user_id"></a> [user\_id](#input\_user\_id) | (Optional) The ID of the User which should be assigned to this Subscription. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the API Management subscription. |
| <a name="output_primary_key"></a> [primary\_key](#output\_primary\_key) | The primary subscription key to use for the subscription. |
| <a name="output_secondary_key"></a> [secondary\_key](#output\_secondary\_key) | The secondary subscription key to use for the subscription. |
<!-- END_TF_DOCS -->