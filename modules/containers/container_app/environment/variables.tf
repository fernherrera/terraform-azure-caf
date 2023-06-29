variable "name" {
  description = "(Required) The name of the Container Apps Managed Environment. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the Container App Environment is to be created. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the Container App Environment is to exist. Changing this forces a new resource to be created."
}

variable "log_analytics_workspace_id" {
  description = "(Required) The ID for the Log Analytics Workspace to link this Container Apps Managed Environment to. Changing this forces a new resource to be created."
}

variable "infrastructure_subnet_id" {
  description = "(Optional) The existing Subnet to use for the Container Apps Control Plane. Changing this forces a new resource to be created. The Subnet must have a /21 or larger address space."
  default     = null
}

variable "internal_load_balancer_enabled" {
  description = "(Optional) Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Changing this forces a new resource to be created. Note: can only be set to true if infrastructure_subnet_id is specified."
  default     = false
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}