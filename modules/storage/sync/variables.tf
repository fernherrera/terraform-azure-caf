variable "create_resource_group" {
  description = "Whether to create resource group."
  default     = false
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Storage Sync should exist. Changing this forces a new Storage Sync to be created."
  default     = ""
}

variable "location" {
  description = "(Required) The Azure Region where the Storage Sync should exist. Changing this forces a new Storage Sync to be created.'"
  default     = ""
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Storage Sync."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) The name which should be used for this Storage Sync. Changing this forces a new Storage Sync to be created."
  type        = string
}

variable "incoming_traffic_policy" {
  description = "(Optional) Incoming traffic policy. Possible values are AllowAllTraffic and AllowVirtualNetworksOnly."
  default     = "AllowAllTraffic"
}

variable "sync_groups" {
  description = "List Storage Sync Groups to create."
  type        = list(string)
  default     = []
}

variable "cloud_endpoints" {
  description = "A map of cloud endpoints to create."
  default     = {}
}

variable "storage_accounts" {
  default = {}
}