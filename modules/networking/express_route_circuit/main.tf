#----------------------------------------------------------
# Local configuration - Default (required). 
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
# Express Route Circuit
#----------------------------------------------------------
resource "azurerm_express_route_circuit" "circuit" {
  name                     = var.name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  tags                     = local.tags
  service_provider_name    = try(var.service_provider_name, "Equinix")
  peering_location         = try(var.peering_location, "Silicon Valley")
  bandwidth_in_mbps        = try(var.bandwidth_in_mbps, 50)
  allow_classic_operations = try(var.allow_classic_operations, false)
  express_route_port_id    = try(var.express_route_port_id, null)
  bandwidth_in_gbps        = try(var.bandwidth_in_gbps, null)

  sku {
    tier   = try(var.sku.tier, "Standard")
    family = try(var.sku.family, "MeteredData")
  }
}