variable "name" {
  description = "(Required) Specifies the name of the Virtual WAN."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Virtual WAN."
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
}

variable "disable_vpn_encryption" {
  description = "(Optional) Boolean flag to specify whether VPN encryption is disabled. Defaults to false."
  default     = false
}

variable "allow_branch_to_branch_traffic" {
  description = "(Optional) Boolean flag to specify whether branch to branch traffic is allowed. Defaults to true."
  default     = true
}

variable "office365_local_breakout_category" {
  description = "(Optional) Specifies the Office365 local breakout category. Possible values include: Optimize, OptimizeAndAllow, All, None. Defaults to None."
  default     = "None"
}

variable "type" {
  description = "(Optional) Specifies the Virtual WAN type. Possible Values include: Basic and Standard. Defaults to Standard."
  default     = "Standard"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Virtual WAN."
  default     = {}
}

variable "virtual_hubs" {
  description = "(Optional) A map of virtual hub configuration objects."
  default     = {}
}