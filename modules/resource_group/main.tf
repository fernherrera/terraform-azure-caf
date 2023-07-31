#-------------------------------
# Local Declarations
#-------------------------------
locals {
  id       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
  name     = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

#----------------------------------------------------------
# Resource Group creation or selection
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.existing == true ? 1 : 0

  name = var.name
}

resource "azurerm_resource_group" "rg" {
  count = var.existing == false ? 1 : 0

  name     = lower(var.name)
  location = var.location
  tags     = var.tags
}