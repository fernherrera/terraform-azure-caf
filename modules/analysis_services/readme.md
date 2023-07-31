<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_analysis_services_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/analysis_services_server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_users | (Optional) List of email addresses of admin users. | `list` | `[]` | no |
| backup\_blob\_container\_uri | (Optional) URI and SAS token for a blob container to store backups. | `any` | `null` | no |
| enable\_power\_bi\_service | (Optional) Indicates if the Power BI service is allowed to access or not. | `bool` | `false` | no |
| ipv4\_firewall\_rule | (Optional) One or more ipv4\_firewall\_rule block(s). | `map` | `{}` | no |
| location | (Required) The Azure location where the Analysis Services Server exists. | `string` | n/a | yes |
| name | (Required) The name of the Analysis Services Server. Only lowercase Alphanumeric characters allowed, starting with a letter. | `string` | n/a | yes |
| querypool\_connection\_mode | (Optional) Controls how the read-write server is used in the query pool. If this value is set to All then read-write servers are also used for queries. Otherwise with ReadOnly these servers do not participate in query operations. | `string` | `"ReadOnly"` | no |
| resource\_group\_name | (Required) The name of the Resource Group in which the Analysis Services Server should be exist. | `string` | n/a | yes |
| sku | (Required) SKU for the Analysis Services Server. Possible values are: D1, B1, B2, S0, S1, S2, S4, S8, S9, S8v2 and S9v2. | `string` | n/a | yes |
| tags | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Analysis Services Server. |
| server\_full\_name | The full name of the Analysis Services Server. |
<!-- END_TF_DOCS -->