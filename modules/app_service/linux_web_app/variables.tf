variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Linux Web App should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Linux Web App should exist."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Linux Web App."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) The name which should be used for this Linux Web App."
  type        = string
}

variable "service_plan_id" {
  description = "(Required) The ID of the Service Plan that this Windows App Service will be created in."
}

variable "settings" {
  description = "(Required) Configuration object - Linux Web App configs containing: auth_settings, backup, logs, site_config, sticky_settings, and storage_account."
}

variable "app_settings" {
  description = "(Optional) A map of key-value pairs of App Settings."
  type        = map(string)
  default     = {}
}

variable "client_affinity_enabled" {
  description = "(Optional) Should Client Affinity be enabled?"
  type        = bool
  default     = false
}

variable "client_certificate_enabled" {
  description = "(Optional) Should Client Certificates be enabled?"
  type        = bool
  default     = false
}

variable "client_certificate_mode" {
  description = "(Optional) The Client Certificate mode. Possible values are Required, Optional, and OptionalInteractiveUser. This property has no effect when client_certificate_enabled is false"
  type        = string
  default     = "Optional"
}

variable "client_certificate_exclusion_paths" {
  description = "(Optional) Paths to exclude when using client certificates, separated by ;"
  default     = null
}

variable "connection_strings" {
  description = "(Optional) One or more connection_string blocks."
}

variable "enabled" {
  description = "(Optional) Should the Linux Web App be enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "https_only" {
  description = "(Optional) Should the Linux Web App require HTTPS connections."
  type        = bool
  default     = false
}

variable "identity" {
  description = "(Optional) An identity block"
  default     = null
}

variable "key_vault_reference_identity_id" {
  description = "(Optional) The User Assigned Identity ID used for accessing KeyVault secrets. The identity must be assigned to the application in the identity block."
}

variable "storage_accounts" {
  description = "(Optional) A map of storage account resources."
  default     = {}
}

variable "virtual_network_integration_enabled" {
  description = "Enable VNET integration. `virtual_network_subnet_id` is mandatory if enabled"
  type        = bool
  default     = false
}

variable "virtual_network_subnet_id" {
  description = "(Optional) The subnet id which will be used by this Web App for regional virtual network integration."
  default     = null
}

variable "zip_deploy_file" {
  description = "(Optional) The local path and filename of the Zip packaged application to deploy to this Linux Web App."
  type        = string
  default     = null
}

variable "application_insight" {
  description = "(Optional) An Application Insights block"
  default     = null
}