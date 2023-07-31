resource "azurerm_express_route_circuit_connection" "erc_conn" {
  name                = var.name
  peering_id          = var.peering_id
  peer_peering_id     = var.peer_peering_id
  address_prefix_ipv4 = var.address_prefix_ipv4
  address_prefix_ipv6 = try(var.address_prefix_ipv6, null)
  authorization_key   = try(var.authorization_key, null)
}