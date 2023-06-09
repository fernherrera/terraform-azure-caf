variable "name" {
  description = "Name of the Log Analytics Storage Insights instance"
  type        = string
}

variable "resource_group_name" {
  description = " The name of the Resource Group where the Log Analytics Storage Insights should exist. Changing this forces a new Log Analytics Storage Insights to be created."
}

variable "settings" {
  description = "(Required) Used to handle passthrough paramenters."
}

variable "storage_account_id" {
  description = " The ID of the Storage Account used by this Log Analytics Storage Insights."
}

variable "workspace_id" {
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
}

variable "primary_access_key" {
  description = "(Required) The storage access key to be used to connect to the storage account."
}