#----------------------------------------------------------
# Local configuration - Default (required). 
#----------------------------------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
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
# Private Endpoint Creation or selection 
#----------------------------------------------------------
resource "azurerm_private_endpoint" "pep" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection.name
    private_connection_resource_id = var.private_service_connection.private_connection_resource_id
    is_manual_connection           = try(var.private_service_connection.is_manual_connection, false)
    subresource_names              = var.private_service_connection.subresource_names
    request_message                = try(var.private_service_connection.request_message, null)
  }

  dynamic "private_dns_zone_group" {
    for_each = lookup(var.private_dns_zone_group, "name", null) == null ? [] : [1]

    content {
      name                 = var.private_dns_zone_group.name
      private_dns_zone_ids = var.private_dns_zone_group.private_dns_zone_ids
    }
  }

}