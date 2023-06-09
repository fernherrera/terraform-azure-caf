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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_redis_cache"></a> [redis\_cache](#module\_redis\_cache) | ./redis_cache | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_group.group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_group) | resource |
| [azurerm_api_management_named_value.named_values](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_product.product](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_group.product_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_group) | resource |
| [azurerm_api_management_redis_cache.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_redis_cache) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_location"></a> [additional\_location](#input\_additional\_location) | List of the name of the Azure Region in which the API Management Service should be expanded to. | `list(map(string))` | `[]` | no |
| <a name="input_certificate_configuration"></a> [certificate\_configuration](#input\_certificate\_configuration) | List of certificate configurations | `list(map(string))` | `[]` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | (Optional) Enforce a client certificate to be presented on each request to the gateway? This is only supported when SKU type is `Consumption`. | `bool` | `false` | no |
| <a name="input_create_product_group_and_relationships"></a> [create\_product\_group\_and\_relationships](#input\_create\_product\_group\_and\_relationships) | Create local APIM groups with name identical to products and create a relationship between groups and products | `bool` | `false` | no |
| <a name="input_developer_portal_hostname_configuration"></a> [developer\_portal\_hostname\_configuration](#input\_developer\_portal\_hostname\_configuration) | Developer portal hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Should HTTP/2 be supported by the API Management Service? | `bool` | `false` | no |
| <a name="input_enable_sign_in"></a> [enable\_sign\_in](#input\_enable\_sign\_in) | Should anonymous users be redirected to the sign in page? | `bool` | `false` | no |
| <a name="input_enable_sign_up"></a> [enable\_sign\_up](#input\_enable\_sign\_up) | Can users sign up on the development portal? | `bool` | `false` | no |
| <a name="input_gateway_disabled"></a> [gateway\_disabled](#input\_gateway\_disabled) | (Optional) Disable the gateway in main region? This is only supported when `additional_location` is set. | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | A list of IDs for User Assigned Managed Identity resources to be assigned. This is required when type is set to UserAssigned or SystemAssigned, UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of Managed Service Identity that should be configured on this API Management Service | `string` | `"SystemAssigned"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure location where the API Management Service exists. | `any` | n/a | yes |
| <a name="input_management_hostname_configuration"></a> [management\_hostname\_configuration](#input\_management\_hostname\_configuration) | List of management hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_min_api_version"></a> [min\_api\_version](#input\_min\_api\_version) | (Optional) The version which the control plane API calls to API Management service are limited with version equal to or newer than. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the API Management Service. | `string` | n/a | yes |
| <a name="input_named_values"></a> [named\_values](#input\_named\_values) | Map containing the name of the named values as key and value as values | `list(map(string))` | `[]` | no |
| <a name="input_notification_sender_email"></a> [notification\_sender\_email](#input\_notification\_sender\_email) | Email address from which the notification will be sent | `string` | `null` | no |
| <a name="input_policy_configuration"></a> [policy\_configuration](#input\_policy\_configuration) | Map of policy configuration | `map(string)` | `{}` | no |
| <a name="input_portal_hostname_configuration"></a> [portal\_hostname\_configuration](#input\_portal\_hostname\_configuration) | Legacy portal hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_products"></a> [products](#input\_products) | List of products to create | `list(string)` | `[]` | no |
| <a name="input_proxy_hostname_configuration"></a> [proxy\_hostname\_configuration](#input\_proxy\_hostname\_configuration) | List of proxy hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_publisher_email"></a> [publisher\_email](#input\_publisher\_email) | (Required) The email of publisher/company. | `string` | n/a | yes |
| <a name="input_publisher_name"></a> [publisher\_name](#input\_publisher\_name) | (Required) The name of publisher/company. | `string` | n/a | yes |
| <a name="input_redis_cache_configuration"></a> [redis\_cache\_configuration](#input\_redis\_cache\_configuration) | Map of redis cache configurations | `map` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the API Management Service should be exist. | `any` | n/a | yes |
| <a name="input_scm_hostname_configuration"></a> [scm\_hostname\_configuration](#input\_scm\_hostname\_configuration) | List of scm hostname configurations | `list(map(string))` | `[]` | no |
| <a name="input_security_configuration"></a> [security\_configuration](#input\_security\_configuration) | Map of security configuration | `map(string)` | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Required) String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity | `string` | `"Basic_1"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Virtual subnet networks configuration object | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags assigned to the resource. | `map(string)` | `{}` | no |
| <a name="input_terms_of_service_configuration"></a> [terms\_of\_service\_configuration](#input\_terms\_of\_service\_configuration) | Map of terms of service configuration | `list(map(string))` | <pre>[<br>  {<br>    "consent_required": false,<br>    "enabled": false,<br>    "text": ""<br>  }<br>]</pre> | no |
| <a name="input_virtual_network_configuration"></a> [virtual\_network\_configuration](#input\_virtual\_network\_configuration) | The id(s) of the subnet(s) that will be used for the API Management. Required when virtual\_network\_type is External or Internal | `any` | `null` | no |
| <a name="input_virtual_network_type"></a> [virtual\_network\_type](#input\_virtual\_network\_type) | The type of virtual network you want to use, valid values include: None, External, Internal. | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_management_additional_location"></a> [api\_management\_additional\_location](#output\_api\_management\_additional\_location) | Map listing gateway\_regional\_url and public\_ip\_addresses associated |
| <a name="output_api_management_gateway_regional_url"></a> [api\_management\_gateway\_regional\_url](#output\_api\_management\_gateway\_regional\_url) | The Region URL for the Gateway of the API Management Service |
| <a name="output_api_management_gateway_url"></a> [api\_management\_gateway\_url](#output\_api\_management\_gateway\_url) | The URL of the Gateway for the API Management Service |
| <a name="output_api_management_id"></a> [api\_management\_id](#output\_api\_management\_id) | The ID of the API Management Service |
| <a name="output_api_management_identity"></a> [api\_management\_identity](#output\_api\_management\_identity) | The identity of the API Management |
| <a name="output_api_management_management_api_url"></a> [api\_management\_management\_api\_url](#output\_api\_management\_management\_api\_url) | The URL for the Management API associated with this API Management service |
| <a name="output_api_management_name"></a> [api\_management\_name](#output\_api\_management\_name) | The name of the API Management Service |
| <a name="output_api_management_portal_url"></a> [api\_management\_portal\_url](#output\_api\_management\_portal\_url) | The URL for the Publisher Portal associated with this API Management service |
| <a name="output_api_management_private_ip_addresses"></a> [api\_management\_private\_ip\_addresses](#output\_api\_management\_private\_ip\_addresses) | The Private IP addresses of the API Management Service |
| <a name="output_api_management_public_ip_addresses"></a> [api\_management\_public\_ip\_addresses](#output\_api\_management\_public\_ip\_addresses) | The Public IP addresses of the API Management Service |
| <a name="output_api_management_scm_url"></a> [api\_management\_scm\_url](#output\_api\_management\_scm\_url) | The URL for the SCM Endpoint associated with this API Management service |
<!-- END_TF_DOCS -->