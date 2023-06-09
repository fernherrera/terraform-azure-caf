variable "name" {
  description = "(Required) Specifies the name of the EventHub resource. Changing this forces a new resource to be created."
}

variable "namespace_name" {
  description = "(Required) Specifies the name of the EventHub Namespace. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the EventHub's parent Namespace exists. Changing this forces a new resource to be created."
}

variable "partition_count" {
  description = "(Required) Specifies the current number of shards on the Event Hub. Changing this will force-recreate the resource."
}

variable "message_retention" {
  description = "(Required) Specifies the number of days to retain the events for this Event Hub."
}

variable "capture_description" {
  description = "(Optional) A capture_description block."
  default     = {}
}

variable "status" {
  description = "(Optional) Specifies the status of the Event Hub resource. Possible values are Active, Disabled and SendDisabled. Defaults to Active."
  default     = null
}

variable "storage_account_id" {
  description = "Identifier of the storage account ID to be used."
  type        = string
  default     = null
}

variable "auth_rules" {
  default = {}
}