variable "name" {
  description = "(Required) The name which should be used for this Express Route Circuit Connection. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "peering_id" {
  description = "(Required) The ID of the Express Route Circuit Private Peering that this Express Route Circuit Connection connects with. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "peer_peering_id" {
  description = "(Required) The ID of the peered Express Route Circuit Private Peering. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "address_prefix_ipv4" {
  description = "(Required) The IPv4 address space from which to allocate customer address for global reach. Changing this forces a new Express Route Circuit Connection to be created."
}

variable "authorization_key" {
  description = "(Optional) The authorization key which is associated with the Express Route Circuit Connection."
  default     = null
}

variable "address_prefix_ipv6" {
  description = "(Optional) The IPv6 address space from which to allocate customer addresses for global reach."
  default     = null
}