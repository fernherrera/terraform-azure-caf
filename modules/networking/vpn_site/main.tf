#----------------------------------------------------------
# Local declarations
#----------------------------------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#----------------------------------------------------------
# VPN Site
#----------------------------------------------------------
resource "azurerm_vpn_site" "vpn" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  virtual_wan_id      = var.virtual_wan_id
  address_cidrs       = try(var.address_cidrs, [])
  device_model        = try(var.device_model, null)
  device_vendor       = try(var.device_vendor, null)

  dynamic "link" {
    for_each = try(var.link, {})

    content {
      name          = link.name
      fqdn          = try(link.fqdn, null)
      ip_address    = try(link.ip_address, null)
      provider_name = try(link.provider_name, null)
      speed_in_mbps = try(link.speed_in_mbps, 0)

      dynamic "bgp" {
        for_each = try(link.bgp, {}) != {} ? [1] : []

        content {
          asn             = bgp.asn
          peering_address = bgp.peering_address
        }
      }
    }
  }

  dynamic "o365_policy" {
    for_each = try(var.o365_policy, {}) != {} ? [1] : []

    content {
      dynamic "traffic_category" {
        for_each = try(o365_policy.traffic_category, {}) != {} ? [1] : []

        content {
          allow_endpoint_enabled    = try(traffic_category.allow_endpoint_enabled, false)
          default_endpoint_enabled  = try(traffic_category.default_endpoint_enabled, false)
          optimize_endpoint_enabled = try(traffic_category.optimize_endpoint_enabled, false)
        }
      }
    }
  }
}