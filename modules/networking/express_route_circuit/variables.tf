variable "name" {
  description = "(Required) The name of the ExpressRoute circuit."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the ExpressRoute circuit."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists."
  type        = string
}

variable "sku" {
  description = "(Required) A sku block for the ExpressRoute circuit"
  type = map(object({
    tier   = string
    family = string
  }))
}

variable "service_provider_name" {
  description = "(Optional) The name of the ExpressRoute Service Provider."
  default     = null
}

variable "peering_location" {
  description = "(Optional) The name of the peering location and not the Azure resource location."
  default     = null
}

variable "bandwidth_in_mbps" {
  description = "(Optional) The bandwidth in Mbps of the circuit being created on the Service Provider."
  default     = null
}

variable "allow_classic_operations" {
  description = "(Optional) Allow the circuit to interact with classic (RDFE) resources. Defaults to false."
  default     = false
}

variable "express_route_port_id" {
  description = "(Optional) The ID of the Express Route Port this Express Route Circuit is based on."
  default     = null
}

variable "bandwidth_in_gbps" {
  description = "(Optional) The bandwidth in Gbps of the circuit being created on the Express Route Port."
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}