variable "name" {
  description = "(Required) Specifies the name which should be used for this Private DNS Resolver."
  type        = string
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group where the Private DNS Resolver should exist."
}

variable "location" {
  description = "(Required) Specifies the Azure Region where the Private DNS Resolver should exist."
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Private DNS Resolver."
  default     = {}
}

variable "virtual_network_id" {
  description = "(Required) The ID of the Virtual Network that is linked to the Private DNS Resolver. Changing this forces a new Private DNS Resolver to be created."
}

variable "inbound_endpoints" {
  default = {}
}

variable "outbound_endpoints" {
  default = {}
}

variable "forwarding_rulesets" {
  default = {}
}

variable "virtual_networks" {
  default = {}
}

variable "virtual_subnets" {
  default = {}
}