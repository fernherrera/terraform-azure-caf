#--------------------------------------
# Variables
#--------------------------------------

## Subsciprion IDs for connectivty and management landing zones.
variable "subscription_id_connectivity" {
  description = "Sets the Subscription ID to use for Connectivity resources."
  type        = string
  default     = ""
}

variable "subscription_id_management" {
  description = "Sets the Subscription ID to use for Management resources."
  type        = string
  default     = ""
}

## Global settings
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

## Messaging
variable "messaging" {
  description = "Configuration object - messaging resources"
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
