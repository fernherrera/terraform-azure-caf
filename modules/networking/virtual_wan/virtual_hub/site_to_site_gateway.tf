#----------------------------------------------------------
# Site-to-Site VPN Gateway
#----------------------------------------------------------
resource "azurerm_vpn_gateway" "s2s_gateway" {
  depends_on = [azurerm_virtual_hub.vwan_hub]
  count      = try(var.s2s_gateways, {})

  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  virtual_hub_id      = azurerm_virtual_hub.vwan_hub.id

  scale_unit         = each.value.scale_unit
  routing_preference = try(each.value.routing_preference, "Microsoft Network")

  dynamic "bgp_settings" {
    for_each = try(each.value.bgp_settings, null) == null ? [] : [1]

    content {
      asn         = each.value.bgp_settings.asn
      peer_weight = each.value.bgp_settings.peer_weight

      dynamic "instance_0_bgp_peering_address" {
        for_each = try(each.value.bgp_settings.instance_0_bgp_peering_address, null) == null ? [] : [1]

        content {
          custom_ips = each.value.bgp_settings.instance_0_bgp_peering_address.custom_ips
        }
      }

      dynamic "instance_1_bgp_peering_address" {
        for_each = try(each.value.bgp_settings.instance_1_bgp_peering_address, null) == null ? [] : [1]

        content {
          custom_ips = each.value.bgp_settings.instance_1_bgp_peering_address.custom_ips
        }
      }

    }
  }

  timeouts {
    create = "60m"
    delete = "120m"
  }
}

#----------------------------------------------------------
# Security Partner Provider
#----------------------------------------------------------
resource "azurerm_virtual_hub_security_partner_provider" "spp" {
  depends_on = [azurerm_vpn_gateway.s2s_gateway]
  for_each   = { for k, v in var.s2s_gateways : k => v if can(v.security_partner_provider) }

  name                   = v.name
  resource_group_name    = local.resource_group_name
  location               = local.location
  virtual_hub_id         = azurerm_virtual_hub.vwan_hub.id
  security_provider_name = v.security_provider_name
  tags                   = local.tags
}