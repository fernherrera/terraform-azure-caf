variable "name" {
  description = "(Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "allow_resource_only_permissions" {
  description = "(Optional) Specifies if the log Analytics Workspace allow users accessing to data associated with resources they have permission to view, without permission to workspace. Defaults to true."
  default     = true
}

variable "existing" {
  description = "(Optional) Whether to reference an existing resource group."
  default     = false
  type        = bool
}

variable "local_authentication_disabled" {
  description = "(Optional) Specifies if the log Analytics workspace should enforce authentication using Azure AD. Defaults to false."
  default     = false
}

variable "sku" {
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03)."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = number
  default     = 7
}

variable "daily_quota_gb" {
  description = "(Optional) The workspace daily quota for ingestion in GB. Defaults to -1 (unlimited) if omitted."
  type        = number
  default     = -1
}

variable "cmk_for_query_forced" {
  description = "(Optional) Is Customer Managed Storage mandatory for query management?"
  default     = null
}

variable "internet_ingestion_enabled" {
  description = "(Optional) Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true."
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "(Optional) Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true."
  type        = bool
  default     = true
}

variable "reservation_capacity_in_gb_per_day" {
  description = "(Optional) The capacity reservation level in GB for this workspace. Must be in increments of 100 between 100 and 5000."
  type        = number
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "solutions_maps" {
  default = {}
}

variable "diagnostic_settings" {
  description = "(Optional) A diagnostic settings block."
  default     = {}
}