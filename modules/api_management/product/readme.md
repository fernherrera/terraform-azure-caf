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
| [azurerm_api_management_product.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | (Required) The name of the API Management Service. | `string` | n/a | yes |
| <a name="input_approval_required"></a> [approval\_required](#input\_approval\_required) | (Optional) Do subscribers need to be approved prior to being able to use the Product? | `string` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of this Product, which may include HTML formatting tags. | `any` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Required) The Display Name for this API Management Product. | `string` | n/a | yes |
| <a name="input_product_id"></a> [product\_id](#input\_product\_id) | (Required) The Identifier for this Product, which must be unique within the API Management Service. | `string` | n/a | yes |
| <a name="input_published"></a> [published](#input\_published) | (Required) Is this Product Published? | `string` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the API Management Service should be exist. | `string` | n/a | yes |
| <a name="input_subscription_required"></a> [subscription\_required](#input\_subscription\_required) | (Required) Is a Subscription required to access API's included in this Product? | `string` | `true` | no |
| <a name="input_subscriptions_limit"></a> [subscriptions\_limit](#input\_subscriptions\_limit) | (Optional) The number of subscriptions a user can have to this Product at the same time. | `string` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the API Management Product. |
<!-- END_TF_DOCS -->