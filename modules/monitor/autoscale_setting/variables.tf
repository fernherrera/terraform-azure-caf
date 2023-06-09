variable "name" {
  description = "(Required) The name of the AutoScale Setting. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in the AutoScale Setting should be created. Changing this forces a new resource to be created."
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "target_resource_id" {
  description = "(Required) Specifies the resource ID of the resource that the autoscale setting should be added to."
}

variable "profiles" {
  description = "(Required) Specifies one or more (up to 20) profile blocks."
}

variable "enabled" {
  description = "(Optional) Specifies whether automatic scaling is enabled for the target resource. Defaults to true."
  default     = true
}

variable "notification" {
  description = "(Optional) Specifies a notification block."
  default     = {}
}