variable "erc_peering" {
  type = map(object({
    peering_type                  = string
    express_route_circuit_name    = string
    resource_group_name           = string
    peer_asn                      = number
    primary_peer_address_prefix   = string
    secondary_peer_address_prefix = string
    vlan_id                       = number
  }))
  default = {}
}