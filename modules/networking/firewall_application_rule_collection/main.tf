#----------------------------------------------------------
# Local declarations
#----------------------------------------------------------
locals {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

#----------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#----------------------------------------------------------
# Firewall Application Rule collection
#----------------------------------------------------------
resource "azurerm_firewall_application_rule_collection" "rule" {
  name                = local.name
  resource_group_name = local.resource_group_name
  azure_firewall_name = var.azure_firewall_name
  priority            = var.priority
  action              = var.action

  dynamic "rule" {
    for_each = try(var.rules, {})

    content {
      name             = rule.value.name
      description      = try(rule.value.description, null)
      source_addresses = try(rule.value.source_addresses, [])
      source_ip_groups = try(rule.value.source_ip_groups, [])
      target_fqdns     = try(rule.value.target_fqdns, [])
      fqdn_tags        = try(rule.value.fqdn_tags, [])

      dynamic "protocol" {
        for_each = try(rule.valueprotocol, {})

        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }
    }

  }
}