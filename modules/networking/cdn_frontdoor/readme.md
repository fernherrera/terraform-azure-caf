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
| [azurerm_cdn_frontdoor_custom_domain.domains](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_endpoint.ep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_origin.org](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.orggrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.fd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_secret.secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_secret) | resource |
| [azurerm_key_vault_certificate.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_domains"></a> [custom\_domains](#input\_custom\_domains) | A map of Front Door (standard/premium) custom domain objects. | `map` | `{}` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | A list of Front Door (standard/premium) endpoints objects. | `map` | `{}` | no |
| <a name="input_key_vaults"></a> [key\_vaults](#input\_key\_vaults) | value | `map` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Front Door Profile. | `any` | n/a | yes |
| <a name="input_origin_groups"></a> [origin\_groups](#input\_origin\_groups) | A map of Front Door (standard/premium) origin group objects. | `map` | `{}` | no |
| <a name="input_origins"></a> [origins](#input\_origins) | A map of Front Door (standard/premium) origin objects. | `map` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where this Front Door Profile should exist. | `any` | n/a | yes |
| <a name="input_response_timeout_seconds"></a> [response\_timeout\_seconds](#input\_response\_timeout\_seconds) | (Optional) Specifies the maximum response timeout in seconds. Possible values are between 16 and 240 seconds (inclusive). Defaults to 120 seconds. | `number` | `120` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | A map of Front Door (standard/premium) route objects. | `map` | `{}` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A map of Front Door Secret objects. | `map` | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) Specifies the SKU for this Front Door Profile. Possible values include Standard\_AzureFrontDoor and Premium\_AzureFrontDoor. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Specifies a mapping of tags to assign to the resource. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_domains"></a> [custom\_domains](#output\_custom\_domains) | Front Door Custom Domains |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | Front Door Endpoints. |
| <a name="output_id"></a> [id](#output\_id) | The ID of this Front Door Profile. |
| <a name="output_origin_groups"></a> [origin\_groups](#output\_origin\_groups) | Front Door Origin Groups |
| <a name="output_resource_guid"></a> [resource\_guid](#output\_resource\_guid) | The UUID of this Front Door Profile which will be sent in the HTTP Header as the X-Azure-FDID attribute. |
| <a name="output_routes"></a> [routes](#output\_routes) | Front Door Routes |
<!-- END_TF_DOCS -->