#----------------------------------------------------------
# Local configuration - Default (required). 
#----------------------------------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )

  forwarding_rules = { for rule in local.forwarding_rules_flattened : rule.name => rule }

  forwarding_rules_flattened = flatten([
    for key, ruleset in var.forwarding_rulesets : [
      for rule in ruleset.rules : merge(
        rule,
        {
          name         = format("%s-%s", ruleset.name, rule.name)
          ruleset_name = ruleset.name
          ruleset_key  = key
        },
      )
    ]
  ])

  vnet_links = { for vlink in local.vnet_links_flattened : vlink.key => vlink }

  vnet_links_flattened = flatten([
    for key, ruleset in var.forwarding_rulesets : [
      for vlink in try(ruleset.vnet_links, []) :
      {
        key                 = format("%s-%s", ruleset.name, try(vlink.name, vlink.virtual_network_key))
        name                = try(vlink.name, null)
        virtual_network_id  = try(vlink.virtual_network_id, var.virtual_network_id)
        virtual_network_key = try(vlink.virtual_network_key, null)
        ruleset_key         = key
        metadata            = try(vlink.metadata, {})
      }
    ]
  ])
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

#----------------------------------------------------------
# Private DNS Resolver
#----------------------------------------------------------
resource "azurerm_private_dns_resolver" "rsv" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  virtual_network_id  = var.virtual_network_id
}

#----------------------------------------------------------
# Private DNS Resolver Inbound Endpoint
#----------------------------------------------------------
resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  for_each = try(var.inbound_endpoints, {})

  name                    = each.value.name
  private_dns_resolver_id = azurerm_private_dns_resolver.rsv.id
  location                = azurerm_private_dns_resolver.rsv.location
  tags                    = local.tags


  dynamic "ip_configurations" {
    for_each = lookup(each.value, "ip_configurations", {})

    content {
      private_ip_allocation_method = lookup(ip_configurations.value, "private_ip_allocation_method", null)
      subnet_id                    = try(ip_configurations.value.subnet_id, var.virtual_subnets.subnets[ip_configurations.value.subnet_key].id, null)
    }
  }
}

#----------------------------------------------------------
# Private DNS Resolver Outbound Endpoint
#----------------------------------------------------------
resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  for_each = try(var.outbound_endpoints, {})

  name                    = each.value.name
  private_dns_resolver_id = azurerm_private_dns_resolver.rsv.id
  location                = azurerm_private_dns_resolver.rsv.location
  tags                    = local.tags
  subnet_id               = can(each.value.subnet_id) ? each.value.subnet_id : try(var.virtual_subnets.subnets[each.value.subnet_key].id, null)
}

#--------------------------------------------------------------------
# Private DNS Resolver Forwarding Rulesets
#--------------------------------------------------------------------
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "ruleset" {
  for_each = try(var.forwarding_rulesets, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  private_dns_resolver_outbound_endpoint_ids = can(each.value.private_dns_resolver_outbound_endpoint_ids) ? each.value.private_dns_resolver_outbound_endpoint_ids : [try(azurerm_private_dns_resolver_outbound_endpoint.outbound[each.value.outbound_endpoint_key].id, null)]
}

#--------------------------------------------------------------------
# Private DNS Resolver Forwarding Rules
#--------------------------------------------------------------------
resource "azurerm_private_dns_resolver_forwarding_rule" "forwarding_rules" {
  for_each = local.forwarding_rules

  name                      = each.value.name
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset[each.value.ruleset_key].id
  domain_name               = each.value.domain_name
  enabled                   = try(each.value.enabled, true)

  dynamic "target_dns_servers" {
    for_each = each.value.dns_servers_ips
    iterator = elem
    content {
      ip_address = elem.value
      port       = 53 # Fixed value
    }
  }
}

#--------------------------------------------------------------------
# Private DNS Resolver Vnet links
#--------------------------------------------------------------------
resource "azurerm_private_dns_resolver_virtual_network_link" "drvl" {
  for_each = local.vnet_links

  name                      = try(each.value.name, "${each.key}-link")
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.ruleset[each.value.ruleset_key].id
  virtual_network_id        = try(each.value.virtual_network_id, var.virtual_networks.vnets[each.value.virtual_network_key].id)
  metadata                  = try(each.value.metadata, {})
}