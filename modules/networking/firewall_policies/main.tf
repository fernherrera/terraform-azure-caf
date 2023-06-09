#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = local.tags
}

#----------------------------------------------------------
# Firewall Policy Resource Creation
#----------------------------------------------------------
resource "azurerm_firewall_policy" "fwpol" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  base_policy_id           = try(var.base_policy_id, null)
  sku                      = try(var.sku, null)
  private_ip_ranges        = try(var.private_ip_ranges, null)
  threat_intelligence_mode = try(var.threat_intelligence_mode, "Alert")

  dynamic "dns" {
    for_each = try(var.dns, null) == null ? [] : [1]

    content {
      servers       = try(var.dns.servers, null)
      proxy_enabled = try(var.dns.proxy_enabled, false)
    }
  }

  dynamic "threat_intelligence_allowlist" {
    for_each = try(var.threat_intelligence_allowlist, null) == null ? [] : [1]

    content {
      ip_addresses = try(var.threat_intelligence_allowlist.ip_addresses, null)
      fqdns        = try(var.threat_intelligence_allowlist.fqdns, null)
    }
  }

  dynamic "intrusion_detection" {
    for_each = try(var.intrusion_detection, null) == null ? [] : [1]

    content {
      mode = try(var.intrusion_detection.mode, "Off")

      dynamic "signature_overrides" {
        for_each = try(var.intrusion_detection.signature_overrides, {})

        content {
          id    = try(signature_overrides.value.id, null)
          state = try(signature_overrides.value.state, null)
        }
      }

      dynamic "traffic_bypass" {
        for_each = try(var.intrusion_detection.traffic_bypass, {})

        content {
          name                  = traffic_bypass.value.name
          protocol              = traffic_bypass.value.protocol
          description           = try(traffic_bypass.value.description, null)
          destination_addresses = try(traffic_bypass.value.destination_addresses, null)
          destination_ip_groups = try(traffic_bypass.value.destination_ip_groups, null)
          destination_ports     = try(traffic_bypass.value.destination_ports, null)
          source_addresses      = try(traffic_bypass.value.source_addresses, null)
          source_ip_groups      = try(traffic_bypass.value.source_ip_groups, null)

        }
      }
    }
  }
}