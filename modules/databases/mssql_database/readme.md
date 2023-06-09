<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diagnostics"></a> [diagnostics](#module\_diagnostics) | ../../monitor/diagnostic_settings | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.mssqldb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [null_resource.set_db_permissions](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_storage_account.mssqldb_tdp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud"></a> [cloud](#input\_cloud) | n/a | `any` | n/a | yes |
| <a name="input_diagnostic_profiles"></a> [diagnostic\_profiles](#input\_diagnostic\_profiles) | n/a | `map` | `{}` | no |
| <a name="input_diagnostics"></a> [diagnostics](#input\_diagnostics) | n/a | `any` | `null` | no |
| <a name="input_elastic_pool_id"></a> [elastic\_pool\_id](#input\_elastic\_pool\_id) | n/a | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `any` | n/a | yes |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | n/a | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. | `string` | n/a | yes |
| <a name="input_server_id"></a> [server\_id](#input\_server\_id) | n/a | `any` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | n/a | `any` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | n/a | `any` | n/a | yes |
| <a name="input_sqlcmd_dbname"></a> [sqlcmd\_dbname](#input\_sqlcmd\_dbname) | n/a | `any` | `null` | no |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_server_fqdn"></a> [server\_fqdn](#output\_server\_fqdn) | n/a |
| <a name="output_server_id"></a> [server\_id](#output\_server\_id) | n/a |
| <a name="output_server_name"></a> [server\_name](#output\_server\_name) | n/a |
<!-- END_TF_DOCS -->