resource "azurerm_express_route_circuit_peering" "erc_peering" {
  for_each                      = var.erc_peering
  peering_type                  = each.value["peering_type"]
  express_route_circuit_name    = each.value["express_route_circuit_name"]
  resource_group_name           = each.value["resource_group_name"]
  peer_asn                      = each.value["peer_asn"]
  primary_peer_address_prefix   = each.value["primary_peer_address_prefix"]
  secondary_peer_address_prefix = each.value["secondary_peer_address_prefix"]
  vlan_id                       = each.value["vlan_id"]

}