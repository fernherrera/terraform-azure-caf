variable "name" {
  description = "(Required) Specifies the name of the Authorization Rule. Changing this forces a new resource to be created."
}

variable "namespace_name" {
  description = "(Required) Specifies the name of the EventHub Namespace. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the EventHub Namespace exists. Changing this forces a new resource to be created."
}

variable "listen" {
  description = "(Optional) Grants listen access to this this Authorization Rule. Defaults to false."
  type        = bool
  default     = false
}

variable "send" {
  description = "(Optional) Grants send access to this this Authorization Rule. Defaults to false."
  type        = bool
  default     = false
}

variable "manage" {
  description = "(Optional) Grants manage access to this this Authorization Rule. When this property is true - both listen and send must be too. Defaults to false."
  type        = bool
  default     = false
}