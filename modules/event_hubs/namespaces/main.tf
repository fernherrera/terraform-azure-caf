#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = try(var.tags, {})
}

#---------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#--------------------------------------
# Event Hub Namespaces
#--------------------------------------
resource "azurerm_eventhub_namespace" "evh" {
  name                          = var.name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  tags                          = local.tags
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
    for_each = try(var.identity, {})

    content {
      type = identity.value.type
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