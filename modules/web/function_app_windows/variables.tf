variable "name" {
  description = "(Required) The name which should be used for this Windows Function App. Changing this forces a new Windows Function App to be created. Limit the function name to 32 characters to avoid naming collisions. For more information about Function App naming rule and Host ID Collisions"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Windows Function App should exist. Changing this forces a new Windows Function App to be created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Windows Function App should exist. Changing this forces a new Windows Function App to be created."
  type        = string
}

variable "service_plan_id" {
  description = "(Required) The ID of the App Service Plan within which to create this Function App."
}

variable "app_settings" {
  description = "(Optional) A map of key-value pairs of App Settings."
  type        = map(string)
  default     = {}
}

variable "builtin_logging_enabled" {
  description = "(Optional) Should built in logging be enabled. Configures AzureWebJobsDashboard app setting based on the configured storage setting. Defaults to true."
  default     = true
}

variable "client_certificate_enabled" {
  description = "(Optional) Should the function app use Client Certificates."
  default     = null
}

variable "client_certificate_mode" {
  description = "(Optional) The mode of the Function App's client certificates requirement for incoming requests. Possible values are Required, Optional, and OptionalInteractiveUser."
  default     = "Optional"
}

variable "client_certificate_exclusion_paths" {
  description = "(Optional) Paths to exclude when using client certificates, separated by ;"
  default     = null
}

variable "connection_strings" {
  description = "(Optional) One or more connection_string blocks."
  default     = {}
}

variable "content_share_force_disabled" {
  description = "(Optional) Should Content Share Settings be disabled. Defaults to false."
  default     = false
}

variable "daily_memory_time_quota" {
  description = "(Optional) The amount of memory in gigabyte-seconds that your application is allowed to consume per day. Setting this value only affects function apps under the consumption plan. Defaults to 0."
  default     = 0
}

variable "enabled" {
  description = "(Optional) Is the Function App enabled? Defaults to true."
  default     = true
}

variable "functions_extension_version" {
  description = "(Optional) The runtime version associated with the Function App. Defaults to ~4."
  default     = "~4"
}

variable "https_only" {
  description = "(Optional) Can the Function App only be accessed via HTTPS? Defaults to false."
  default     = false
}

variable "identity" {
  description = "(Optional) An identity block."
  default     = null
}

variable "key_vault_reference_identity_id" {
  description = "(Optional) The User Assigned Identity Id used for looking up KeyVault secrets. The identity must be assigned to the application."
  default     = null
}

variable "storage_account" {
  description = "(Optional) One or more storage_account blocks."
  default     = {}
}

variable "storage_account_access_key" {
  description = "(Optional) The access key which will be used to access the backend storage account for the Function App. Conflicts with storage_uses_managed_identity."
  default     = null
}

variable "storage_account_name" {
  description = "(Optional) The backend storage account name which will be used by this Function App."
  default     = null
}

variable "storage_uses_managed_identity" {
  description = "(Optional) Should the Function App use Managed Identity to access the storage account. Conflicts with storage_account_access_key."
  default     = null
}

variable "storage_key_vault_secret_id" {
  description = "(Optional) The Key Vault Secret ID, optionally including version, that contains the Connection String to connect to the storage account for this Function App."
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Windows Web App."
  type        = map(string)
  default     = {}
}

variable "virtual_network_integration_enabled" {
  description = "Enable VNET integration. `virtual_network_subnet_id` is mandatory if enabled"
  type        = bool
  default     = false
}

variable "virtual_network_subnet_id" {
  description = "(Optional) The subnet id which will be used by this Function App for regional virtual network integration."
  default     = null
}

variable "application_insight" {
  description = "(Optional) The application insights instance used to log to."
  default     = null
}

variable "settings" {
  description = "Configuration object - Windows Web App"
  default     = {}
}