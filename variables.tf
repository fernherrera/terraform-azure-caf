#--------------------------------------
# Variables
#--------------------------------------

# Global settings
variable "global_settings" {
  description = "Global settings object for the current deployment."
  default = {
    passthrough    = false
    default_region = "region1"
    regions = {
      region1 = "eastus"
      region2 = "westus"
    }
  }
}

variable "client_config" {
  default = {}
}

## Cloud variables
variable "cloud" {
  description = "Configuration object - Cloud resources defaults to Azure public, allows you to switch to other Azure endpoints."
  default = {
    acrLoginServerEndpoint                      = ".azurecr.io"
    attestationEndpoint                         = ".attest.azure.net"
    azureDatalakeAnalyticsCatalogAndJobEndpoint = "azuredatalakeanalytics.net"
    azureDatalakeStoreFileSystemEndpoint        = "azuredatalakestore.net"
    keyvaultDns                                 = ".vault.azure.net"
    mariadbServerEndpoint                       = ".mariadb.database.azure.com"
    mhsmDns                                     = ".managedhsm.azure.net"
    mysqlServerEndpoint                         = ".mysql.database.azure.com"
    postgresqlServerEndpoint                    = ".postgres.database.azure.com"
    sqlServerHostname                           = ".database.windows.net"
    storageEndpoint                             = "core.windows.net"
    storageSyncEndpoint                         = "afs.azure.net"
    synapseAnalyticsEndpoint                    = ".dev.azuresynapse.net"
    activeDirectory                             = "https://login.microsoftonline.com"
    activeDirectoryDataLakeResourceId           = "https://datalake.azure.net/"
    activeDirectoryGraphResourceId              = "https://graph.windows.net/"
    activeDirectoryResourceId                   = "https://management.core.windows.net/"
    appInsightsResourceId                       = "https://api.applicationinsights.io"
    appInsightsTelemetryChannelResourceId       = "https://dc.applicationinsights.azure.com/v2/track"
    attestationResourceId                       = "https://attest.azure.net"
    azmirrorStorageAccountResourceId            = "null"
    batchResourceId                             = "https://batch.core.windows.net/"
    gallery                                     = "https://gallery.azure.com/"
    logAnalyticsResourceId                      = "https://api.loganalytics.io"
    management                                  = "https://management.core.windows.net/"
    mediaResourceId                             = "https://rest.media.azure.net"
    microsoftGraphResourceId                    = "https://graph.microsoft.com/"
    ossrdbmsResourceId                          = "https://ossrdbms-aad.database.windows.net"
    portal                                      = "https://portal.azure.com"
    resourceManager                             = "https://management.azure.com/"
    sqlManagement                               = "https://management.core.windows.net:8443/"
    synapseAnalyticsResourceId                  = "https://dev.azuresynapse.net"
    vmImageAliasDoc                             = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json"
  }
}

variable "data_sources" {
  description = "Data gathering for resources not managed by CAF Module"
  default     = {}
}

variable "enable" {
  description = "Map of services defined in the configuration file you want to disable during a deployment."
  default = {
    # bastion_hosts    = true
    # virtual_machines = true
  }
}

variable "environment" {
  description = "Name of the LZ environment."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

#--------------------------------------------------------------------

## Analysis Services
variable "analysis_services" {
  description = "Configuration object - Analysis Services resources"
  default     = {}
}

## API Management
variable "apim" {
  description = "Configuration object - API Management resources"
  default     = {}
}

## Compute variables
variable "compute" {
  description = "Configuration object - Azure compute resources"
  default     = {}
}

## Databases variables
variable "database" {
  description = "Configuration object - databases resources"
  default     = {}
}

## Data Factory
variable "data_factory" {
  description = "Configuration object - Data Factory resources."
  default     = {}
}

## Networking variables
variable "networking" {
  description = "Configuration object - networking resources"
  default     = {}
}

## Remote objects
variable "remote_objects" {
  description = "Allow the landing zone to retrieve remote tfstate objects and pass them to the CAF module."
  default     = {}
}

## Resource Groups
variable "resource_groups" {
  description = "Configuration object - Resource groups."
  default     = {}
}

## Security variables
variable "security" {
  description = "Configuration object - security resources"
  default     = {}
}

## Shared services
variable "shared_services" {
  description = "Configuration object - Shared services resources"
  default     = {}
}

## Storage
variable "storage" {
  description = "Configuration object - Storage resources"
  default     = {}
}

## App services, App service plans, and function apps
variable "web" {
  description = "Configuration object - Web Applications"
  default     = {}
}






# Diagnostics settings
variable "diagnostics" {
  description = "Configuration object - Diagnostics object."
  default     = {}
}

variable "diagnostics_definition" {
  description = "Configuration object - Shared diadgnostics settings that can be used by the services to enable diagnostics."
  default     = null
}

variable "diagnostics_destinations" {
  description = "Configuration object - Describes the destinations for the diagnostics."
  default     = null
}

variable "diagnostic_storage_accounts" {
  description = "Configuration object - Storage account for diagnostics resources"
  default     = {}
}

# Event hubs
variable "event_hub_namespaces" {
  description = "Configuration object - Event Hub Namespaces."
  default     = {}
}

variable "event_hubs" {
  description = "Configuration object - Event Hub resources"
  default     = {}
}

variable "event_hub_auth_rules" {
  description = "Configuration object - Event Hub authentication rules"
  default     = {}
}

variable "event_hub_namespace_auth_rules" {
  description = "Configuration object - Event Hub namespaces authentication rules"
  default     = {}
}

variable "event_hub_consumer_groups" {
  description = "Configuration object - Event Hub consumer group rules"
  default     = {}
}
