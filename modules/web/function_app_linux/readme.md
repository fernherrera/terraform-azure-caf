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
| [azurerm_linux_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_client_config.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | (Optional) A map of key-value pairs of App Settings. | `map(string)` | `{}` | no |
| <a name="input_application_insight"></a> [application\_insight](#input\_application\_insight) | (Optional) The application insights instance used to log to. | `any` | `null` | no |
| <a name="input_builtin_logging_enabled"></a> [builtin\_logging\_enabled](#input\_builtin\_logging\_enabled) | (Optional) Should built in logging be enabled. Configures AzureWebJobsDashboard app setting based on the configured storage setting. Defaults to true. | `bool` | `true` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | (Optional) Should the function app use Client Certificates. | `any` | `null` | no |
| <a name="input_client_certificate_exclusion_paths"></a> [client\_certificate\_exclusion\_paths](#input\_client\_certificate\_exclusion\_paths) | (Optional) Paths to exclude when using client certificates, separated by ; | `any` | `null` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are Required, Optional, and OptionalInteractiveUser. | `string` | `"Optional"` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | (Optional) One or more connection\_string blocks. | `map` | `{}` | no |
| <a name="input_content_share_force_disabled"></a> [content\_share\_force\_disabled](#input\_content\_share\_force\_disabled) | (Optional) Should Content Share Settings be disabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_daily_memory_time_quota"></a> [daily\_memory\_time\_quota](#input\_daily\_memory\_time\_quota) | (Optional) The amount of memory in gigabyte-seconds that your application is allowed to consume per day. Setting this value only affects function apps under the consumption plan. Defaults to 0. | `number` | `0` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Is the Function App enabled? Defaults to true. | `bool` | `true` | no |
| <a name="input_functions_extension_version"></a> [functions\_extension\_version](#input\_functions\_extension\_version) | (Optional) The runtime version associated with the Function App. Defaults to ~4. | `string` | `"~4"` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | (Optional) Can the Function App only be accessed via HTTPS? Defaults to false. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block. | `map` | `{}` | no |
| <a name="input_key_vault_reference_identity_id"></a> [key\_vault\_reference\_identity\_id](#input\_key\_vault\_reference\_identity\_id) | (Optional) The User Assigned Identity Id used for looking up KeyVault secrets. The identity must be assigned to the application. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the App Function | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `""` | no |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | (Required) The ID of the App Service Plan within which to create this Function App. | `any` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Configuration object - Linux Function App | `any` | n/a | yes |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | (Optional) One or more storage\_account blocks. | `map` | `{}` | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | (Optional) The access key which will be used to access the backend storage account for the Function App. Conflicts with storage\_uses\_managed\_identity. | `any` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | (Optional) The backend storage account name which will be used by this Function App. | `any` | `null` | no |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | n/a | `map` | `{}` | no |
| <a name="input_storage_key_vault_secret_id"></a> [storage\_key\_vault\_secret\_id](#input\_storage\_key\_vault\_secret\_id) | (Optional) The Key Vault Secret ID, optionally including version, that contains the Connection String to connect to the storage account for this Function App. | `any` | `null` | no |
| <a name="input_storage_uses_managed_identity"></a> [storage\_uses\_managed\_identity](#input\_storage\_uses\_managed\_identity) | (Optional) Should the Function App use Managed Identity to access the storage account. Conflicts with storage\_account\_access\_key. | `any` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the Windows Web App. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_integration_enabled"></a> [virtual\_network\_integration\_enabled](#input\_virtual\_network\_integration\_enabled) | Enable VNET integration. `virtual_network_subnet_id` is mandatory if enabled | `bool` | `false` | no |
| <a name="input_virtual_network_subnet_id"></a> [virtual\_network\_subnet\_id](#input\_virtual\_network\_subnet\_id) | (Optional) The subnet id which will be used by this Function App for regional virtual network integration. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_domain_vertification_id"></a> [custom\_domain\_vertification\_id](#output\_custom\_domain\_vertification\_id) | The identifier used by App Service to perform domain ownership verification via DNS TXT record. |
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | The default hostname of the Linux Function App. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Linux Function App. |
| <a name="output_identity"></a> [identity](#output\_identity) | The managed identity block from the Function app |
| <a name="output_kind"></a> [kind](#output\_kind) | The Kind value for this Linux Function App. |
| <a name="output_outbound_ip_address_list"></a> [outbound\_ip\_address\_list](#output\_outbound\_ip\_address\_list) | A list of outbound IP addresses. For example ["52.23.25.3", "52.143.43.12"] |
| <a name="output_outbound_ip_addresses"></a> [outbound\_ip\_addresses](#output\_outbound\_ip\_addresses) | A comma separated list of outbound IP addresses as a string. For example 52.23.25.3,52.143.43.12. |
| <a name="output_possible_outbound_ip_address_list"></a> [possible\_outbound\_ip\_address\_list](#output\_possible\_outbound\_ip\_address\_list) | A list of possible outbound IP addresses, not all of which are necessarily in use. This is a superset of outbound\_ip\_address\_list. For example ["52.23.25.3", "52.143.43.12"]. |
| <a name="output_possible_outbound_ip_addresses"></a> [possible\_outbound\_ip\_addresses](#output\_possible\_outbound\_ip\_addresses) | A comma separated list of possible outbound IP addresses as a string. For example 52.23.25.3,52.143.43.12,52.143.43.17. This is a superset of outbound\_ip\_addresses. For example ["52.23.25.3", "52.143.43.12", "52.143.43.17"]. |
| <a name="output_site_credential"></a> [site\_credential](#output\_site\_credential) | The site credential block |
<!-- END_TF_DOCS -->