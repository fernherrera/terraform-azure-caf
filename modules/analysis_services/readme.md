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
| [azurerm_analysis_services_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/analysis_services_server) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_users"></a> [admin\_users](#input\_admin\_users) | (Optional) List of email addresses of admin users. | `list` | `[]` | no |
| <a name="input_backup_blob_container_uri"></a> [backup\_blob\_container\_uri](#input\_backup\_blob\_container\_uri) | (Optional) URI and SAS token for a blob container to store backups. | `any` | `null` | no |
| <a name="input_enable_power_bi_service"></a> [enable\_power\_bi\_service](#input\_enable\_power\_bi\_service) | (Optional) Indicates if the Power BI service is allowed to access or not. | `bool` | `false` | no |
| <a name="input_ipv4_firewall_rule"></a> [ipv4\_firewall\_rule](#input\_ipv4\_firewall\_rule) | (Optional) One or more ipv4\_firewall\_rule block(s). | `map` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure location where the Analysis Services Server exists. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Analysis Services Server. Only lowercase Alphanumeric characters allowed, starting with a letter. | `string` | n/a | yes |
| <a name="input_querypool_connection_mode"></a> [querypool\_connection\_mode](#input\_querypool\_connection\_mode) | (Optional) Controls how the read-write server is used in the query pool. If this value is set to All then read-write servers are also used for queries. Otherwise with ReadOnly these servers do not participate in query operations. | `string` | `"ReadOnly"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group in which the Analysis Services Server should be exist. | `string` | `""` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) SKU for the Analysis Services Server. Possible values are: D1, B1, B2, S0, S1, S2, S4, S8, S9, S8v2 and S9v2. | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Analysis Services Server. |
| <a name="output_server_full_name"></a> [server\_full\_name](#output\_server\_full\_name) | The full name of the Analysis Services Server. |
<!-- END_TF_DOCS -->