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
# Firewall Resource Creation
#----------------------------------------------------------
resource "azurerm_firewall" "fw" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  dns_servers        = try(var.dns_servers, null)
  firewall_policy_id = try(var.firewall_policy_id, null)
  private_ip_ranges  = try(var.private_ip_ranges, null)
  sku_name           = try(var.sku_name, "AZFW_VNet")
  sku_tier           = try(var.sku_tier, "Standard")
  threat_intel_mode  = try(var.virtual_hub, null) != null ? "" : try(var.threat_intel_mode, "Alert")
  zones              = try(var.zones, null)

  dynamic "ip_configuration" {
    for_each = try(var.ip_configuration, {})

    content {
      name                 = ip_configuration.value.name
      public_ip_address_id = try(ip_configuration.value.public_ip_address_id, null) != null ? ip_configuration.value.public_ip_address_id : var.public_ip_addresses[ip_configuration.value.public_ip_key].id
      subnet_id            = try(ip_configuration.value.subnet_id, null) != null ? ip_configuration.value.subnet_id : var.virtual_networks[ip_configuration.value.vnet_key].subnets[ip_configuration.value.subnet_key].id
    }
  }

  dynamic "management_ip_configuration" {
    for_each = try(var.management_ip_configuration, {})

    content {
      name                 = management_ip_configuration.value.name
      public_ip_address_id = try(management_ip_configuration.value.public_ip_address_id, null) != null ? management_ip_configuration.value.public_ip_address_id : var.public_ip_addresses[management_ip_configuration.value.public_ip_key].id
      subnet_id            = try(management_ip_configuration.value.subnet_id, null) != null ? management_ip_configuration.value.subnet_id : var.virtual_networks[management_ip_configuration.value.vnet_key].subnets[management_ip_configuration.value.subnet_key].id
    }
  }

  dynamic "virtual_hub" {
    for_each = {
      for key, value in try(var.virtual_hub, {}) : key => value
      if can(value.virtual_wan_key) == false
    }

    content {
      virtual_hub_id  = can(virtual_hub.value.virtual_hub_id) ? virtual_hub.value.virtual_hub_id : var.virtual_hubs[virtual_hub.value.virtual_hub_key].id
      public_ip_count = try(virtual_hub.value.public_ip_count, 1)
    }
  }

  dynamic "virtual_hub" {
    for_each = {
      for key, value in try(var.virtual_hub, {}) : key => value
      if can(value.virtual_wan_key)
    }

    content {
      virtual_hub_id  = can(var.virtual_hubs[virtual_hub.value.virtual_hub_key].id) ? var.virtual_hubs[virtual_hub.value.virtual_hub_key].id : var.virtual_wans[virtual_hub.value.virtual_wan_key].virtual_hubs[virtual_hub.value.virtual_hub_key].id
      public_ip_count = try(virtual_hub.value.public_ip_count, 1)
    }
  }

  lifecycle {
    ignore_changes = [
      virtual_hub
    ]
  }
}