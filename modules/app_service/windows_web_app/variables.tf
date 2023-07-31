variable "name" {
  description = "(Required) The name which should be used for this Windows Web App. Changing this forces a new Windows Web App to be created."
  type        = string
}

variable "resource_group_name" {
  description = " (Required) The name of the Resource Group where the Windows Web App should exist. Changing this forces a new Windows Web App to be created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Windows Web App should exist. Changing this forces a new Windows Web App to be created."
  type        = string
}

variable "service_plan_id" {
  description = "(Required) The ID of the Service Plan that this Windows App Service will be created in."
}

variable "application_insight" {
  default = null
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
  description = "(Optional) The Client Certificate mode. Possible values include Optional and Required. This property has no effect when client_cert_enabled is false"
  type        = string
  default     = "Optional"
}

variable "connection_strings" {
  description = "(Optional) One or more connection_string blocks"
}

variable "enabled" {
  description = "(Optional) Should the Windows Web App be enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "https_only" {
  description = "(Optional) Should the Windows Web App require HTTPS connections."
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

variable "settings" {
  description = "Configuration object - Windows Web App"
}

variable "storage_accounts" {
  description = "(Optional)"
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
  description = "(Optional) The subnet id which will be used by this Web App for regional virtual network integration."
  default     = null
}

variable "zip_deploy_file" {
  description = "(Optional) The local path and filename of the Zip packaged application to deploy to this Windows Web App."
  type        = string
  default     = null
}

variable "private_dns" {
  default = {}
}

variable "private_endpoints" {
  default = {}
}

variable "resource_groups" {
  default = {}
}

variable "virtual_subnets" {
  default = {}
}