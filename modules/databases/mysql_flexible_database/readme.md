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
| [azurerm_mysql_flexible_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_charset"></a> [charset](#input\_charset) | (Required) Specifies the Charset for the MySQL Database, which needs to be a valid MySQL Charset. | `string` | n/a | yes |
| <a name="input_collation"></a> [collation](#input\_collation) | (Required) Specifies the Collation for the MySQL Database, which needs to be a valid MySQL Collation. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the MySQL Database, which needs to be a valid MySQL identifier. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which the MySQL Server exists. | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | (Required) Specifies the name of the MySQL Flexible Server. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the MySQL Database. |
<!-- END_TF_DOCS -->