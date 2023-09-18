#-------------------------------
# Local Declarations
#-------------------------------
locals {
  id   = element(coalescelist(data.azurerm_eventhub_namespace.evh_e.*.id, azurerm_eventhub_namespace.evh.*.id, [""]), 0)
  name = element(coalescelist(data.azurerm_eventhub_namespace.evh_e.*.name, azurerm_eventhub_namespace.evh.*.name, [""]), 0)
}

#--------------------------------------
# Event Hub Namespaces
#--------------------------------------
data "azurerm_eventhub_namespace" "evh_e" {
  count = var.existing == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventhub_namespace" "evh" {
  count = var.existing == false ? 1 : 0

  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = var.tags
  sku                           = var.sku
  capacity                      = try(var.capacity, null)
  auto_inflate_enabled          = try(var.auto_inflate_enabled, null)
  dedicated_cluster_id          = try(var.dedicated_cluster_id, null)
  maximum_throughput_units      = try(var.maximum_throughput_units, null)
  zone_redundant                = try(var.zone_redundant, null)
  minimum_tls_version           = try(var.minimum_tls_version, null)
  public_network_access_enabled = try(var.public_network_access_enabled, null)
  local_authentication_enabled  = try(var.local_authentication_enabled, null)

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [1] : []

    content {
      type         = identity.value.type
      identity_ids = concat(identity.value.managed_identities, [])
    }
  }

  dynamic "network_rulesets" {
    for_each = try(var.network_rulesets, {})

    content {
      default_action                 = network_rulesets.value.default_action #Possible values are Allow and Deny. Defaults to Deny.
      trusted_service_access_enabled = try(network_rulesets.value.trusted_service_access_enabled, null)

      dynamic "virtual_network_rule" {
        for_each = try(var.network_rulesets.virtual_network_rule, {})

        content {
          subnet_id                                       = virtual_network_rule.value.subnet_id
          ignore_missing_virtual_network_service_endpoint = try(virtual_network_rule.value.ignore_missing_virtual_network_service_endpoint, null)
        }
      }

      dynamic "ip_rule" {
        for_each = try(var.network_rulesets.ip_rule, {})

        content {
          ip_mask = ip_rule.value.ip_mask
          action  = try(ip_rule.value.action, null)
        }
      }
    }
  }
}