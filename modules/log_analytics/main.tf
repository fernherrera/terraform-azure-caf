#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#---------------------------------------------------------
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

#---------------------------------------------------------
# Log Analytics Workspace Resource Creation
#----------------------------------------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  daily_quota_gb                     = try(var.daily_quota_gb, null)
  internet_ingestion_enabled         = try(var.internet_ingestion_enabled, null)
  internet_query_enabled             = try(var.internet_query_enabled, null)
  reservation_capacity_in_gb_per_day = var.sku == "CapacityReservation" ? try(var.reservation_capacity_in_gb_per_day, null) : null
  sku                                = try(var.sku, "PerGB2018")
  retention_in_days                  = try(var.retention_in_days, 30)
}