variable "name" {
  description = "(Required) The name of the Virtual Hub."
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group where the Virtual Hub should exist."
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the Virtual Hub should exist."
}

variable "address_prefix" {
  description = "(Optional) The Address Prefix which should be used for this Virtual Hub. Changing this forces a new resource to be created. The address prefix subnet cannot be smaller than a /24. Azure recommends using a /23."
  default     = null
}

variable "route" {
  description = "(Optional) One or more route blocks"
  default     = {}
}

variable "sku" {
  description = "(Optional) The SKU of the Virtual Hub. Possible values are Basic and Standard."
  default     = "Basic"
}

variable "virtual_wan_id" {
  description = "(Optional) The ID of a Virtual WAN within which the Virtual Hub should be created."
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Virtual Hub."
  default     = {}
}

variable "connections" {
  description = "(Optional) One or more connection blocks."
  default     = {}
}

variable "express_route_gateways" {
  description = "(Optional) One or more Express Route Gateway blocks."
  default     = {}
}

variable "p2s_gateways" {
  description = "(Optional) One or more Point-to-Site VPN Gateway blocks."
  default     = {}
}

variable "s2s_gateways" {
  description = "(Optional) One or more Site-to-Site VPN Gateway blocks."
  default     = {}
}