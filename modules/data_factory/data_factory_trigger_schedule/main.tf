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
resource "azurerm_data_factory_trigger_schedule" "schedule" {
  name                = var.name
  data_factory_id     = var.data_factory_id
  pipeline_name       = var.pipeline_name
  start_time          = try(var.settings.start_time, null)
  end_time            = try(var.settings.end_time, null)
  interval            = try(var.settings.interval, null)
  frequency           = try(var.settings.frequency, null)
  pipeline_parameters = try(var.settings.pipeline_parameters, null)
  annotations         = try(var.settings.annotations, null)
}