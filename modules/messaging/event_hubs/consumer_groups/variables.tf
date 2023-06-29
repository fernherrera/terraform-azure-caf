variable "name" {
  description = "(Required) Specifies the name of the EventHub Consumer Group resource. Changing this forces a new resource to be created."
  type        = string
}

variable "namespace_name" {
  description = "(Required) Specifies the name of the grandparent EventHub Namespace. Changing this forces a new resource to be created."
  type        = string
}

variable "eventhub_name" {
  description = "(Required) Specifies the name of the EventHub. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the EventHub Consumer Group's grandparent Namespace exists. Changing this forces a new resource to be created."
  type        = string
}

variable "user_metadata" {
  description = "(Optional) Specifies the user metadata."
  default     = null
}