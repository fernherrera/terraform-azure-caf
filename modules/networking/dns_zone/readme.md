<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_records"></a> [records](#module\_records) | ./records | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Whether to create resource group and use it for all networking resources | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the DNS Zone. Must be a valid domain name. | `any` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | (Optional) Configuration map - DNS Records. | `map` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `any` | n/a | yes |
| <a name="input_soa_record"></a> [soa\_record](#input\_soa\_record) | (Optional) An soa\_record block | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | DNS Zone resource ID. |
| <a name="output_max_number_of_record_sets"></a> [max\_number\_of\_record\_sets](#output\_max\_number\_of\_record\_sets) | Maximum number of Records in the zone. |
| <a name="output_name"></a> [name](#output\_name) | The fully qualified domain name of the Record Set. |
| <a name="output_name_servers"></a> [name\_servers](#output\_name\_servers) | A list of values that make up the NS record for the zone. |
| <a name="output_records"></a> [records](#output\_records) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Resource group name of the dns\_zone |
| <a name="output_soa_record"></a> [soa\_record](#output\_soa\_record) | The SOA record. |
<!-- END_TF_DOCS -->