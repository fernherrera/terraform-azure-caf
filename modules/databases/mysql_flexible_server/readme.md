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
| [azurerm_mysql_flexible_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server) | resource |
| [azurerm_mysql_flexible_server_firewall_rule.fwRules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | (Optional) The Administrator login for the MySQL Flexible Server. Required when create\_mode is Default. | `any` | `null` | no |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | (Optional) The Password associated with the administrator\_login for the MySQL Flexible Server. Required when create\_mode is Default. | `any` | `null` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Optional) The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7. | `number` | `7` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | (Optional)The creation mode which can be used to restore or replicate existing servers. Possible values are Default, PointInTimeRestore, GeoRestore, and Replica. | `string` | `"Default"` | no |
| <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key) | (Optional) A customer\_managed\_key block. | `map` | `{}` | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | (Optional) The ID of the virtual network subnet to create the MySQL Flexible Server. | `any` | `null` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | (Optional) A list of firewall rule objects. | `list` | `[]` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | (Optional) Should geo redundant backup enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | (Optional) A high\_availability block. | `map` | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block. | `map` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure Region where the MySQL Flexible Server should exist. | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Optional) A maintenance\_window block. | `map` | `{}` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | (Optional) The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this MySQL Flexible Server. | `string` | n/a | yes |
| <a name="input_point_in_time_restore_time_in_utc"></a> [point\_in\_time\_restore\_time\_in\_utc](#input\_point\_in\_time\_restore\_time\_in\_utc) | (Optional) The point in time to restore from creation\_source\_server\_id when create\_mode is PointInTimeRestore. | `any` | `null` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | (Optional) The ID of the private DNS zone to create the MySQL Flexible Server. | `any` | `null` | no |
| <a name="input_replication_role"></a> [replication\_role](#input\_replication\_role) | (Optional) The replication role. Possible value is None. | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where the MySQL Flexible Server should exist. | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | (Optional) The SKU Name for the MySQL Flexible Server.  sku\_name should start with SKU tier B (Burstable), GP (General Purpose), MO (Memory Optimized) like B\_Standard\_B1s. | `any` | `null` | no |
| <a name="input_source_server_id"></a> [source\_server\_id](#input\_source\_server\_id) | (Optional)The resource ID of the source MySQL Flexible Server to be restored. Required when create\_mode is PointInTimeRestore, GeoRestore, and Replica. | `any` | `null` | no |
| <a name="input_storage"></a> [storage](#input\_storage) | (Optional) A storage block. | `map` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags which should be assigned to the MySQL Flexible Server. | `map(string)` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The fully qualified domain name of the MySQL Flexible Server. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the MySQL Flexible Server. |
| <a name="output_name"></a> [name](#output\_name) | The name of the MySQL Flexible Server. |
| <a name="output_public_network_access_enabled"></a> [public\_network\_access\_enabled](#output\_public\_network\_access\_enabled) | Is the public network access enabled? |
| <a name="output_replica_capacity"></a> [replica\_capacity](#output\_replica\_capacity) | The maximum number of replicas that a primary MySQL Flexible Server can have. |
<!-- END_TF_DOCS -->