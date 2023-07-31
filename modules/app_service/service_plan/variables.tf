variable "name" {
  description = "(Required) The name which should be used for this Service Plan. Changing this forces a new AppService to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the AppService should exist. Changing this forces a new AppService to be created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Service Plan should exist. Changing this forces a new AppService to be created."
  type        = string
}

variable "os_type" {
  description = "(Required) The O/S type for the App Services to be hosted in this plan. Possible values include Windows, Linux, and WindowsContainer."
  type        = string
  default     = "Windows"
}

variable "sku_name" {
  description = "(Required) The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."
  type        = string
  default     = "S1"
}

variable "app_service_environment_id" {
  description = "(Optional) The ID of the App Service Environment to create this Service Plan in."
  default     = null
}

variable "maximum_elastic_worker_count" {
  description = "(Optional) The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU."
}

variable "worker_count" {
  description = "(Optional) The number of Workers (instances) to be allocated."
}

variable "per_site_scaling_enabled" {
  description = "(Optional) Should Per Site Scaling be enabled. Defaults to false."
  default     = false
}

variable "zone_balancing_enabled" {
  description = "(Optional) Should the Service Plan balance across Availability Zones in the region. Defaults to false."
  default     = false
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the AppService."
  type        = map(string)
  default     = {}
}
