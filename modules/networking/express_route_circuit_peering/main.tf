resource "azurerm_express_route_circuit_peering" "peering" {
  express_route_circuit_name = var.express_route_circuit_name
  resource_group_name        = var.resource_group_name
  peering_type               = var.peering_type
  vlan_id                    = var.vlan_id

  ipv4_enabled                  = try(var.ipv4_enabled, true)
  primary_peer_address_prefix   = try(var.primary_peer_address_prefix, null)
  secondary_peer_address_prefix = try(var.secondary_peer_address_prefix, null)
  peer_asn                      = try(var.peer_asn, null)

  dynamic "ipv6" {
    for_each = try(var.ipv6, {}) != {} ? [1] : []

    content {
      primary_peer_address_prefix   = ipv6.primary_peer_address_prefix
      secondary_peer_address_prefix = ipv6.secondary_peer_address_prefix
      enabled                       = try(ipv6.enabled, true)
      route_filter_id               = try(ipv6.route_filter_id, null)

      dynamic "microsoft_peering" {
        for_each = try(ipv6.microsoft_peering, {}) != {} ? [1] : []

        content {
          advertised_public_prefixes = try(microsoft_peering.advertised_public_prefixes, null)
          advertised_communities     = try(microsoft_peering.advertised_communities, null)
          customer_asn               = try(microsoft_peering.customer_asn, null)
          routing_registry_name      = try(microsoft_peering.routing_registry_name, null)
        }
      }
    }
  }

  dynamic "microsoft_peering_config" {
    for_each = try(var.microsoft_peering_config, {}) != {} ? [1] : []

    content {
      advertised_public_prefixes = microsoft_peering_config.advertised_public_prefixes
      advertised_communities     = try(microsoft_peering_config.advertised_communities, null)
      customer_asn               = try(microsoft_peering_config.customer_asn, null)
      routing_registry_name      = try(microsoft_peering_config.routing_registry_name, null)
    }
  }
}