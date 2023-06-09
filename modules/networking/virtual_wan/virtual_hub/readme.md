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
| [azurerm_virtual_hub.vwan_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix) | (Optional) The Address Prefix which should be used for this Virtual Hub. Changing this forces a new resource to be created. The address prefix subnet cannot be smaller than a /24. Azure recommends using a /23. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the Virtual Hub should exist. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Virtual Hub. | `any` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Specifies the name of the Resource Group where the Virtual Hub should exist. | `any` | n/a | yes |
| <a name="input_route"></a> [route](#input\_route) | (Optional) One or more route blocks | `map` | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU of the Virtual Hub. Possible values are Basic and Standard. | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the Virtual Hub. | `map` | `{}` | no |
| <a name="input_virtual_wan_id"></a> [virtual\_wan\_id](#input\_virtual\_wan\_id) | (Optional) The ID of a Virtual WAN within which the Virtual Hub should be created. | `any` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->