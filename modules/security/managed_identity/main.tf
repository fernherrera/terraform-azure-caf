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
# Managed Identity
#----------------------------------------------------------
resource "azurerm_user_assigned_identity" "msi" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

}

resource "time_sleep" "propagate_to_azuread" {
  depends_on = [azurerm_user_assigned_identity.msi]

  create_duration = "30s"
}