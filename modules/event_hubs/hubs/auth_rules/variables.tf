variable "name" {
  description = "(Required) Specifies the name of the EventHub Authorization Rule resource. Changing this forces a new resource to be created."
}

variable "namespace_name" {
  description = "(Required) Specifies the name of the grandparent EventHub Namespace. Changing this forces a new resource to be created."
}

variable "eventhub_name" {
  description = "(Required) Specifies the name of the EventHub. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the EventHub Namespace exists. Changing this forces a new resource to be created."
}

variable "listen" {
  description = "(Optional) Does this Authorization Rule have permissions to Listen to the Event Hub? Defaults to false."
  type        = bool
  default     = false
}

variable "send" {
  description = "(Optional) Does this Authorization Rule have permissions to Send to the Event Hub? Defaults to false."
  type        = bool
  default     = false
}

variable "manage" {
  description = "(Optional) Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is true - both listen and send must be too. Defaults to false."
  type        = bool
  default     = false
}