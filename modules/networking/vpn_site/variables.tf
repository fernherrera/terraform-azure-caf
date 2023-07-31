variable "name" {
  description = "(Required) The name which should be used for this VPN Site. Changing this forces a new VPN Site to be created."
}

variable "location" {
  description = "(Required) The Azure Region where the VPN Site should exist. Changing this forces a new VPN Site to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the VPN Site should exist. Changing this forces a new VPN Site to be created."
}

variable "virtual_wan_id" {
  description = "(Required) The ID of the Virtual Wan where this VPN site resides in. Changing this forces a new VPN Site to be created."
}

variable "link" {
  description = "(Optional) One or more link blocks."
  default     = {}
}

variable "address_cidrs" {
  description = "(Optional) Specifies a list of IP address CIDRs that are located on your on-premises site. Traffic destined for these address spaces is routed to your local site."
  default     = []
}

variable "device_model" {
  description = "(Optional) The model of the VPN device."
  default     = null
}

variable "device_vendor" {
  description = "(Optional) The name of the VPN device vendor."
  default     = null
}

variable "o365_policy" {
  description = "(Optional) An o365_policy block."
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the VPN Site."
  default     = {}
}