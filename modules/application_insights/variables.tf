variable "name" {
  description = "(Required) Specifies the name of the Application Insights component."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Application Insights component."
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "application_type" {
  description = "(Required) Specifies the type of Application Insights to create. Valid values are ios for iOS, java for Java web, MobileCenter for App Center, Node.JS for Node.js, other for General, phone for Windows Phone, store for Windows Store and web for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this forces a new resource to be created."
  default     = "other"

  validation {
    condition     = contains(["ios", "java", "MobileCenter", "Node.JS", "other", "phone", "store", "web"], var.application_type)
    error_message = "Provide an authorized value."
  }
}

variable "daily_data_cap_in_gb" {
  description = "(Optional) Specifies the Application Insights component daily data volume cap in GB."
  default     = null
  type        = number
}

variable "daily_data_cap_notifications_disabled" {
  description = "(Optional) Specifies if a notification email will be send when the daily data volume cap is met. (set to false to enable)"
  default     = true
  type        = bool
}

variable "retention_in_days" {
  description = "(Optional) Specifies the retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. Defaults to 90."
  default     = 90
  type        = number

  validation {
    condition     = contains([30, 60, 90, 120, 180, 270, 365, 550, 730], var.retention_in_days)
    error_message = "Provide a valid value for retention period in days."
  }
}

variable "sampling_percentage" {
  description = "(Optional) Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry."
  default     = null
  type        = number
}

variable "disable_ip_masking" {
  description = "(Optional) By default the real client ip is masked as 0.0.0.0 in the logs. Use this argument to disable masking and log the real client ip. Defaults to false."
  default     = false
  type        = bool
}

variable "workspace_id" {
  description = "(Optional) Specifies the id of a log analytics workspace resource."
  default     = null
}

variable "local_authentication_disabled" {
  description = "(Optional) Disable Non-Azure AD based Auth. Defaults to false."
  type        = bool
  default     = false
}

variable "internet_ingestion_enabled" {
  description = "(Optional) Should the Application Insights component support ingestion over the Public Internet? Defaults to true."
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "(Optional) Should the Application Insights component support querying over the Public Internet? Defaults to true."
  type        = bool
  default     = true
}

variable "force_customer_storage_for_profiler" {
  description = "(Optional) Should the Application Insights component force users to create their own storage account for profiling? Defaults to false."
  type        = bool
  default     = false
}

variable "diagnostic_profiles" {
  default = {}
}

variable "diagnostics" {
  default = null
}
