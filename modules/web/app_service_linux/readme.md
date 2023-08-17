<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_custom_hostname_binding.app_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_source_control.scm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_source_control) | resource |
| [azurerm_linux_web_app.web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [time_rotating.http_logs_sas](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [time_rotating.logs_sas](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [time_rotating.sas](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.backup_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account_blob_container_sas.backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_blob_container_sas) | data source |
| [azurerm_storage_account_blob_container_sas.http_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_blob_container_sas) | data source |
| [azurerm_storage_account_blob_container_sas.logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_blob_container_sas) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | (Optional) A map of key-value pairs of App Settings. | `map(string)` | `{}` | no |
| <a name="input_application_insight"></a> [application\_insight](#input\_application\_insight) | (Optional) An Application Insights block | `any` | `null` | no |
| <a name="input_client_affinity_enabled"></a> [client\_affinity\_enabled](#input\_client\_affinity\_enabled) | (Optional) Should Client Affinity be enabled? | `bool` | `false` | no |
| <a name="input_client_certificate_enabled"></a> [client\_certificate\_enabled](#input\_client\_certificate\_enabled) | (Optional) Should Client Certificates be enabled? | `bool` | `false` | no |
| <a name="input_client_certificate_exclusion_paths"></a> [client\_certificate\_exclusion\_paths](#input\_client\_certificate\_exclusion\_paths) | (Optional) Paths to exclude when using client certificates, separated by ; | `any` | `null` | no |
| <a name="input_client_certificate_mode"></a> [client\_certificate\_mode](#input\_client\_certificate\_mode) | (Optional) The Client Certificate mode. Possible values are Required, Optional, and OptionalInteractiveUser. This property has no effect when client\_certificate\_enabled is false | `string` | `"Optional"` | no |
| <a name="input_connection_strings"></a> [connection\_strings](#input\_connection\_strings) | (Optional) One or more connection\_string blocks. | `any` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Should the Linux Web App be enabled? Defaults to true. | `bool` | `true` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | (Optional) Should the Linux Web App require HTTPS connections. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block | `any` | `null` | no |
| <a name="input_key_vault_reference_identity_id"></a> [key\_vault\_reference\_identity\_id](#input\_key\_vault\_reference\_identity\_id) | (Optional) The User Assigned Identity ID used for accessing KeyVault secrets. The identity must be assigned to the application in the identity block. | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the Linux Web App should exist. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Linux Web App. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where the Linux Web App should exist. | `string` | n/a | yes |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | (Required) The ID of the Service Plan that this Windows App Service will be created in. | `any` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | (Required) Configuration object - Linux Web App configs containing: auth\_settings, backup, logs, site\_config, sticky\_settings, and storage\_account. | `any` | n/a | yes |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | (Optional) A map of storage account resources. | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the Linux Web App. | `map(string)` | `{}` | no |
| <a name="input_virtual_network_integration_enabled"></a> [virtual\_network\_integration\_enabled](#input\_virtual\_network\_integration\_enabled) | Enable VNET integration. `virtual_network_subnet_id` is mandatory if enabled | `bool` | `false` | no |
| <a name="input_virtual_network_subnet_id"></a> [virtual\_network\_subnet\_id](#input\_virtual\_network\_subnet\_id) | (Optional) The subnet id which will be used by this Web App for regional virtual network integration. | `any` | `null` | no |
| <a name="input_zip_deploy_file"></a> [zip\_deploy\_file](#input\_zip\_deploy\_file) | (Optional) The local path and filename of the Zip packaged application to deploy to this Linux Web App. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_outbound_ip_addresses"></a> [outbound\_ip\_addresses](#output\_outbound\_ip\_addresses) | A comma separated list of outbound IP addresses |
| <a name="output_possible_outbound_ip_addresses"></a> [possible\_outbound\_ip\_addresses](#output\_possible\_outbound\_ip\_addresses) | A comma separated list of outbound IP addresses. not all of which are necessarily in use |
| <a name="output_site_credential"></a> [site\_credential](#output\_site\_credential) | The output of any site credentials |
| <a name="output_web_app_id"></a> [web\_app\_id](#output\_web\_app\_id) | The ID of the App Service. |
| <a name="output_web_app_name"></a> [web\_app\_name](#output\_web\_app\_name) | The name of the App Service. |
| <a name="output_web_identity"></a> [web\_identity](#output\_web\_identity) | The managed identity block from the Function app |
<!-- END_TF_DOCS -->