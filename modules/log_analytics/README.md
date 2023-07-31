<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_solution.solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_log_analytics_workspace.law_e](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_resource\_only\_permissions | (Optional) Specifies if the log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace. Defaults to true. | `bool` | `true` | no |
| cmk\_for\_query\_forced | (Optional) Is Customer Managed Storage mandatory for query management? | `any` | `null` | no |
| daily\_quota\_gb | (Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted. | `number` | `-1` | no |
| diagnostic\_settings | (Optional) A diagnostic settings block. | `map` | `{}` | no |
| existing | (Optional) Whether to reference an existing resource group. | `bool` | `false` | no |
| internet\_ingestion\_enabled | (Optional) Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true. | `bool` | `true` | no |
| internet\_query\_enabled | (Optional) Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true. | `bool` | `true` | no |
| local\_authentication\_disabled | (Optional) Specifies if the log Analytics workspace should enforce authentication using Azure AD. Defaults to false. | `bool` | `false` | no |
| location | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `any` | n/a | yes |
| name | (Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created. | `string` | n/a | yes |
| reservation\_capacity\_in\_gb\_per\_day | (Optional) The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 5000. | `number` | `null` | no |
| resource\_group\_name | (Required) The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created. | `any` | n/a | yes |
| retention\_in\_days | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `7` | no |
| sku | (Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). | `string` | `"PerGB2018"` | no |
| solutions\_maps | n/a | `map` | `{}` | no |
| tags | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| primary\_shared\_key | n/a |
| secondary\_shared\_key | n/a |
| workspace\_id | n/a |
<!-- END_TF_DOCS -->