# Azure Application Insights Terraform module

Application Insights, a feature of Azure Monitor, is an extensible Application Performance Management (APM) service for developers and DevOps professionals. Use it to monitor your live applications. It will automatically detect performance anomalies, and includes powerful analytics tools to help you diagnose issues. This terraform module quickly creates.

## Module Usage

```terraform
# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "application-insights" {
  source  = "terraform-modules/azurerm/application_insights"

  name                = ""
  location            = "eastus"
  resource_group_name = "rg-shared-eastus-01"
  application_type    = "web"
  tags = {
    environment = "dev"
  }
}
```

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.appinsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_type | (Required) Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created. | `string` | `"other"` | no |
| daily\_data\_cap\_in\_gb | (Optional) Specifies the Application Insights component daily data volume cap in GB. | `number` | `null` | no |
| daily\_data\_cap\_notifications\_disabled | (Optional) Specifies if a notification email will be send when the daily data volume cap is met. (set to false to enable) | `bool` | `true` | no |
| diagnostic\_profiles | n/a | `map` | `{}` | no |
| diagnostics | n/a | `any` | `null` | no |
| disable\_ip\_masking | (Optional) By default the real client ip is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client ip. Defaults to false. | `bool` | `false` | no |
| force\_customer\_storage\_for\_profiler | (Optional) Should the Application Insights component force users to create their own storage account for profiling? Defaults to false. | `bool` | `false` | no |
| internet\_ingestion\_enabled | (Optional) Should the Application Insights component support ingestion over the Public Internet? Defaults to true. | `bool` | `true` | no |
| internet\_query\_enabled | (Optional) Should the Application Insights component support querying over the Public Internet? Defaults to true. | `bool` | `true` | no |
| local\_authentication\_disabled | (Optional) Disable Non-Azure AD based Auth. Defaults to false. | `bool` | `false` | no |
| location | (Required) Specifies the supported Azure location where the resource exists. | `any` | n/a | yes |
| name | (Required) Specifies the name of the Application Insights component. | `string` | n/a | yes |
| resource\_group\_name | (Required) The name of the resource group in which to create the Application Insights component. | `any` | n/a | yes |
| retention\_in\_days | (Optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 90. | `number` | `90` | no |
| sampling\_percentage | (Optional) Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry. | `number` | `null` | no |
| tags | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| workspace\_id | (Optional) Specifies the id of a log analytics workspace resource. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_id | The App ID associated with this Application Insights component. |
| connection\_string | The Connection String for this Application Insights component. (Sensitive) |
| id | The ID of the Application Insights component. |
| instrumentation\_key | The Instrumentation Key for this Application Insights component. |
<!-- END_TF_DOCS -->