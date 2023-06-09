#----------------------------------------------------------
# VPN P2S server configuration
# ## creates the VPN P2S server configuration, this is required for P2S site.
# ## TBD: https://www.terraform.io/docs/providers/azurerm/r/vpn_server_configuration.html
#----------------------------------------------------------
resource "azurerm_vpn_server_configuration" "p2s_configuration" {
  depends_on = [azurerm_virtual_hub.vwan_hub]
  for_each   = try(var.p2s_gateways, {})

  name                     = each.value.server_config.name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  tags                     = local.tags
  vpn_authentication_types = each.value.server_config.vpn_authentication_types

  client_root_certificate {
    name             = each.value.server_config.client_root_certificate.name
    public_cert_data = each.value.server_config.client_root_certificate.public_cert_data
  }
}

#----------------------------------------------------------
# Point-to-Site VPN Gateway
#----------------------------------------------------------
resource "azurerm_point_to_site_vpn_gateway" "p2s_gateway" {
  depends_on = [azurerm_virtual_hub.vwan_hub, azurerm_vpn_server_configuration.p2s_configuration]
  for_each   = try(var.p2s_gateways, {})

  name                        = each.value.name
  location                    = local.location
  resource_group_name         = local.resource_group_name
  tags                        = local.tags
  virtual_hub_id              = azurerm_virtual_hub.vwan_hub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2s_configuration[0].id

  scale_unit = each.value.scale_unit

  dynamic "connection_configuration" {
    for_each = try(each.value.connection_configuration, {}) != {} ? [1] : []

    content {
      name = connection_configuration.name

      dynamic "vpn_client_address_pool" {
        for_each = try(connection_configuration.vpn_client_address_pool, {})
        content {
          address_prefixes = connection_configuration.vpn_client_address_pool.address_prefixes
        }
      }
    }
  }

  timeouts {
    create = "60m"
    delete = "120m"
  }
}