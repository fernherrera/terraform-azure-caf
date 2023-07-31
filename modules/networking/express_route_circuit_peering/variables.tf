variable "express_route_circuit_name" {
  description = "(Required) The name of the ExpressRoute Circuit in which to create the Peering."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Express Route Circuit Peering. Changing this forces a new resource to be created."
  type        = string
}

variable "peering_type" {
  description = "(Required) The type of the ExpressRoute Circuit Peering. Acceptable values include AzurePrivatePeering, AzurePublicPeering and MicrosoftPeering. Changing this forces a new resource to be created."
  type        = string
}

variable "vlan_id" {
  description = "(Required) A valid VLAN ID to establish this peering on."
  type        = number
}

variable "ipv4_enabled" {
  description = "(Optional) A boolean value indicating whether the IPv4 peering is enabled. Defaults to true."
  default     = true
}

variable "ipv6" {
  description = "(Optional) A ipv6 block."
  default     = {}
}

variable "microsoft_peering_config" {
  description = "(Optional) A microsoft_peering_config block as defined below. Required when peering_type is set to MicrosoftPeering."
  default     = {}
}

variable "peer_asn" {
  description = "(Optional) The Either a 16-bit or a 32-bit ASN. Can either be public or private."
  default     = null
  type        = number
}

variable "primary_peer_address_prefix" {
  description = "(Optional) A /30 subnet for the primary link. Required when config for IPv4."
  default     = null
  type        = string
}

variable "secondary_peer_address_prefix" {
  description = "(Optional) A /30 subnet for the secondary link. Required when config for IPv4."
  default     = null
  type        = string
}

variable "shared_key" {
  description = "(Optional) The shared key. Can be a maximum of 25 characters."
  default     = null
  type        = string
}

variable "route_filter_id" {
  description = "(Optional) The ID of the Route Filter. Only available when peering_type is set to MicrosoftPeering."
  default     = null
}
