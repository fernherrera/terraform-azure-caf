variable "name" {
  description = "(Required) The name which should be used for this Linux Web App."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Linux Web App should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Linux Web App should exist."
  type        = string
}

variable "service_plan_id" {
  description = "(Required) The ID of the Service Plan that this Windows App Service will be created in."
}

variable "site_config" {
  description = "(Required) A site_config block."
}

variable "app_settings" {
  description = "(Optional) A map of key-value pairs of App Settings."
  type        = map(string)
  default     = {}
}

variable "auth_settings" {
  description = "(Optional) An auth_settings block."
  default     = {}
}

variable "auth_settings_v2" {
  description = "(Optional) An auth_settings_v2 block."
  default     = {}
}

variable "backup" {
  description = "(Optional) A backup block."
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
  default     = {}
}

variable "custom_hostname_bindings" {
  description = "(Optional) One or more custom_hostname_bindings blocks."
  default     = {}
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

variable "logs" {
  description = "(Optional) A logs block"
  default     = null
}

variable "sticky_settings" {
  description = "(Optional) A sticky_settings block."
  default     = null
}

variable "source_control" {
  default = {}
}

variable "storage_account" {
  description = "(Optional) One or more storage_account blocks."
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Linux Web App."
  type        = map(string)
  default     = {}
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

variable "storage_accounts" {
  description = "(Optional) A map of storage account resources."
  default     = {}
}