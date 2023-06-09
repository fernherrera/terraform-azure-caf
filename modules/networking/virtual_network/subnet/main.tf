#------------------------
# Local declarations
#------------------------
locals {
  resource_group_name  = element(data.azurerm_resource_group.rgrp.*.name, 0)
  location             = element(data.azurerm_resource_group.rgrp.*.location, 0)
  tags                 = merge(try(var.tags, {}), )
  virtual_network_name = element(concat(data.azurerm_virtual_network.vnet.*.name, [""]), 0)
}

data "azurerm_resource_group" "rgrp" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = local.resource_group_name
}

#--------------------------------------------------------------------------------------------------------
# Subnets Creation with, private link endpoint/service network policies, service endpoints and Deligation.
#--------------------------------------------------------------------------------------------------------
resource "azurerm_subnet" "snet" {
  for_each = var.subnets

  name                 = each.value.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network_name
  address_prefixes     = each.value.subnet_address_prefix
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  # private_endpoint_network_policies_enabled      = lookup(each.value, "private_endpoint_network_policies_enabled", true)
  # private_link_service_network_policies_enabled  = lookup(each.value, "private_link_service_network_policies_enabled", true)

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []

    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }
}

#-----------------------------------------------
# Network security group - Default is "false"
#-----------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  for_each = var.subnets

  name                = lower("${each.value.subnet_name}-nsg")
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "Name" = lower("${each.value.subnet_name}-nsg") }, local.tags, )

  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_inbound_rules", []), lookup(each.value, "nsg_outbound_rules", []))

    content {
      name                         = lookup(security_rule.value, "name", "Default_Rule")
      description                  = lookup(security_rule.value, "description", "")
      priority                     = lookup(security_rule.value, "priority", "100")
      direction                    = lookup(security_rule.value, "direction", "Inbound")
      access                       = lookup(security_rule.value, "access", "Allow")
      protocol                     = lookup(security_rule.value, "protocol", "Tcp")
      source_port_range            = lookup(security_rule.value, "source_port_range", "")
      source_port_ranges           = lookup(security_rule.value, "source_port_ranges", [])
      destination_port_range       = lookup(security_rule.value, "destination_port_range", "")
      destination_port_ranges      = lookup(security_rule.value, "destination_port_ranges", [])
      source_address_prefix        = lookup(security_rule.value, "source_address_prefix", element(each.value.subnet_address_prefix, 0))
      source_address_prefixes      = lookup(security_rule.value, "source_address_prefixes", [])
      destination_address_prefix   = lookup(security_rule.value, "destination_address_prefix", element(each.value.subnet_address_prefix, 0))
      destination_address_prefixes = lookup(security_rule.value, "destination_address_prefixes", [])
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}