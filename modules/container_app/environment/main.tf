#---------------------------------
# Local declarations
#---------------------------------
locals {
  name                = var.name
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
# Container App Environment
#----------------------------------------------------------
resource "azurerm_container_app_environment" "cae" {
  name                           = local.name
  location                       = local.location
  resource_group_name            = local.resource_group_name
  tags                           = local.tags
  log_analytics_workspace_id     = try(var.log_analytics_workspace_id, null)
  internal_load_balancer_enabled = try(var.internal_load_balancer_enabled, false)
}