# Cloud Adoption Framework for Azure - Terraform module

Microsoft Cloud Adoption Framework for Azure provides you with guidance and best practices to adopt Azure.

This module allows you to create resources on Microsoft Azure, is used by the Cloud Adoption Framework for Azure (CAF) landing zones to provision resources in an Azure subscription.

## Prerequisites

* Access to an Azure subscription.

## Getting started

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.5 |
| azuread | ~> 2.39.0 |
| azurerm | >= 3.59.0 |
| random | ~> 3.5.1 |
| time | >= 0.9.1 |
| tls | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | ~> 2.39.0 |
| azurerm | >= 3.59.0 |
| azurerm.connectivity | >= 3.59.0 |
| azurerm.management | >= 3.59.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| analysis\_services | ./modules/analysis_services | n/a |
| api\_management | ./modules/api_management | n/a |
| api\_management\_product | ./modules/api_management/product | n/a |
| api\_management\_subscription | ./modules/api_management/subscription | n/a |
| app\_service\_plan\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| app\_service\_plans | ./modules/app_service/service_plan | n/a |
| application\_insights | ./modules/application_insights | n/a |
| cdn\_frontdoors | ./modules/networking/cdn_frontdoor | n/a |
| container\_app\_environment\_certificates | ./modules/containers/container_app/environment_certificate | n/a |
| container\_app\_environment\_dapr\_components | ./modules/containers/container_app/environment_dapr_component | n/a |
| container\_app\_environment\_storage | ./modules/containers/container_app/environment_storage | n/a |
| container\_app\_environments | ./modules/containers/container_app/environment | n/a |
| container\_apps | ./modules/containers/container_app | n/a |
| data\_factory | ./modules/data_factory/data_factory | n/a |
| data\_factory\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| data\_factory\_integration\_runtime\_azure\_ssis | ./modules/data_factory/data_factory_integration_runtime_azure_ssis | n/a |
| data\_factory\_integration\_runtime\_self\_hosted | ./modules/data_factory/data_factory_integration_runtime_self_hosted | n/a |
| data\_factory\_pipeline | ./modules/data_factory/data_factory_pipeline | n/a |
| data\_factory\_private\_endpoints | ./modules/networking/private_endpoint | n/a |
| data\_factory\_trigger\_schedule | ./modules/data_factory/data_factory_trigger_schedule | n/a |
| dns\_zones | ./modules/networking/dns_zone | n/a |
| event\_hub\_auth\_rules | ./modules/messaging/event_hubs/hubs/auth_rules | n/a |
| event\_hub\_consumer\_groups | ./modules/messaging/event_hubs/consumer_groups | n/a |
| event\_hub\_namespace\_auth\_rules | ./modules/messaging/event_hubs/namespaces/auth_rules | n/a |
| event\_hub\_namespaces | ./modules/messaging/event_hubs/namespaces | n/a |
| event\_hub\_namespaces\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| event\_hub\_namespaces\_private\_endpoints | ./modules/networking/private_endpoint | n/a |
| event\_hubs | ./modules/messaging/event_hubs/hubs | n/a |
| express\_route\_circuits | ./modules/networking/express_route_circuit | n/a |
| frontdoors | ./modules/networking/frontdoor | n/a |
| ip\_groups | ./modules/networking/ip_group | n/a |
| keyvault\_access\_policies | ./modules/security/keyvault_access_policies | n/a |
| keyvault\_access\_policies\_azuread\_apps | ./modules/security/keyvault_access_policies | n/a |
| keyvault\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| keyvault\_private\_endpoints | ./modules/networking/private_endpoint | n/a |
| keyvaults | ./modules/security/keyvault | n/a |
| linux\_function\_apps | ./modules/app_service/linux_function_app | n/a |
| linux\_function\_apps\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| linux\_web\_apps | ./modules/app_service/linux_web_app | n/a |
| linux\_web\_apps\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| log\_analytics | ./modules/log_analytics | n/a |
| log\_analytics\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| managed\_identities | ./modules/security/managed_identity | n/a |
| monitor\_autoscale\_settings | ./modules/monitor/autoscale_setting | n/a |
| mssql\_databases | ./modules/databases/mssql_database | n/a |
| mssql\_servers | ./modules/databases/mssql_server | n/a |
| mssql\_servers\_private\_endpoints | ./modules/networking/private_endpoint | n/a |
| mysql\_databases | ./modules/databases/mysql_flexible_database | n/a |
| mysql\_servers | ./modules/databases/mysql_flexible_server | n/a |
| private\_dns | ./modules/networking/private_dns | n/a |
| private\_dns\_resolver | ./modules/networking/private_dns_resolver | n/a |
| redis\_cache | ./modules/databases/redis_cache | n/a |
| resource\_groups | ./modules/resource_group | n/a |
| static\_sites | ./modules/app_service/static_site | n/a |
| storage\_accounts | ./modules/storage/storage_account | n/a |
| storage\_accounts\_private\_endpoints | ./modules/networking/private_endpoint | n/a |
| storage\_syncs | ./modules/storage/storage_sync | n/a |
| virtual\_machines | ./modules/compute/virtual_machine | n/a |
| virtual\_networks | ./modules/networking/virtual_network | n/a |
| virtual\_subnets | ./modules/networking/virtual_network/subnet | n/a |
| windows\_function\_apps | ./modules/app_service/windows_function_app | n/a |
| windows\_function\_apps\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |
| windows\_web\_apps | ./modules/app_service/windows_web_app | n/a |
| windows\_web\_apps\_diagnostics | ./modules/monitor/diagnostic_settings | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_dns_zone.dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| analysis\_services | Configuration object - Analysis Services resources | `map` | `{}` | no |
| apim | Configuration object - API Management resources | `map` | `{}` | no |
| client\_config | n/a | `map` | `{}` | no |
| cloud | Configuration object - Cloud resources defaults to Azure public, allows you to switch to other Azure endpoints. | `map` | ```{ "acrLoginServerEndpoint": ".azurecr.io", "activeDirectory": "https://login.microsoftonline.com", "activeDirectoryDataLakeResourceId": "https://datalake.azure.net/", "activeDirectoryGraphResourceId": "https://graph.windows.net/", "activeDirectoryResourceId": "https://management.core.windows.net/", "appInsightsResourceId": "https://api.applicationinsights.io", "appInsightsTelemetryChannelResourceId": "https://dc.applicationinsights.azure.com/v2/track", "attestationEndpoint": ".attest.azure.net", "attestationResourceId": "https://attest.azure.net", "azmirrorStorageAccountResourceId": "null", "azureDatalakeAnalyticsCatalogAndJobEndpoint": "azuredatalakeanalytics.net", "azureDatalakeStoreFileSystemEndpoint": "azuredatalakestore.net", "batchResourceId": "https://batch.core.windows.net/", "gallery": "https://gallery.azure.com/", "keyvaultDns": ".vault.azure.net", "logAnalyticsResourceId": "https://api.loganalytics.io", "management": "https://management.core.windows.net/", "mariadbServerEndpoint": ".mariadb.database.azure.com", "mediaResourceId": "https://rest.media.azure.net", "mhsmDns": ".managedhsm.azure.net", "microsoftGraphResourceId": "https://graph.microsoft.com/", "mysqlServerEndpoint": ".mysql.database.azure.com", "ossrdbmsResourceId": "https://ossrdbms-aad.database.windows.net", "portal": "https://portal.azure.com", "postgresqlServerEndpoint": ".postgres.database.azure.com", "resourceManager": "https://management.azure.com/", "sqlManagement": "https://management.core.windows.net:8443/", "sqlServerHostname": ".database.windows.net", "storageEndpoint": "core.windows.net", "storageSyncEndpoint": "afs.azure.net", "synapseAnalyticsEndpoint": ".dev.azuresynapse.net", "synapseAnalyticsResourceId": "https://dev.azuresynapse.net", "vmImageAliasDoc": "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json" }``` | no |
| compute | Configuration object - Azure compute resources | `map` | `{}` | no |
| containers | Configuration object - Container resources | `map` | `{}` | no |
| data\_factory | Configuration object - Data Factory resources. | `map` | `{}` | no |
| data\_sources | Data gathering for resources not managed by CAF Module | `map` | `{}` | no |
| database | Configuration object - databases resources | `map` | `{}` | no |
| environment | Name of the LZ environment. | `string` | `"dev"` | no |
| global\_settings | Global settings object for the current deployment. | `map` | ```{ "default_region": "region1", "passthrough": false, "regions": { "region1": "eastus", "region2": "westus" } }``` | no |
| messaging | Configuration object - messaging resources | `map` | `{}` | no |
| networking | Configuration object - networking resources | `map` | `{}` | no |
| remote\_objects | Allow the landing zone to retrieve remote tfstate objects and pass them to the CAF module. | `map` | `{}` | no |
| resource\_groups | Configuration object - Resource groups. | `map` | `{}` | no |
| security | Configuration object - security resources | `map` | `{}` | no |
| shared\_services | Configuration object - Shared services resources | `map` | `{}` | no |
| storage | Configuration object - Storage resources | `map` | `{}` | no |
| subscription\_id\_connectivity | Sets the Subscription ID to use for Connectivity resources. | `string` | `""` | no |
| subscription\_id\_management | Sets the Subscription ID to use for Management resources. | `string` | `""` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| web | Configuration object - Web Applications | `map` | `{}` | no |
<!-- END_TF_DOCS -->