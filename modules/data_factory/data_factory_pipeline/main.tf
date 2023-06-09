#-------------------------------
# Local Declarations
#-------------------------------
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
# Data Factory Creation 
#----------------------------------------------------------
resource "azurerm_data_factory_pipeline" "pipeline" {
  name                           = var.name
  data_factory_id                = var.data_factory_id
  description                    = try(var.settings.description, null)
  annotations                    = try(var.settings.annotations, null)
  concurrency                    = try(var.settings.concurrency, null)
  folder                         = try(var.settings.folder, null)
  moniter_metrics_after_duration = try(var.settings.moniter_metrics_after_duration, null)
  parameters                     = try(var.settings.parameters, null)
  variables                      = try(var.settings.variables, null)
  activities_json                = try(var.settings.activities_json, null)
}