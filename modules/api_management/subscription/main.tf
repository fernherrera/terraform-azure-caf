#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  api_management_name = element(coalescelist(data.azurerm_api_management.apim.*.name, [""]), 0)
}

#----------------------------------------------------------
# Resource Group and APIM selection 
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_api_management" "apim" {
  name                = var.api_management_name
  resource_group_name = var.resource_group_name
}

#----------------------------------------------------------
# API Management Subscription Creation
#----------------------------------------------------------
resource "azurerm_api_management_subscription" "apim" {
  api_management_name = local.api_management_name
  resource_group_name = local.resource_group_name
  display_name        = var.display_name
  product_id          = try(var.product_id, null)
  user_id             = try(var.user_id, null)
  api_id              = try(var.api_id, null)
  primary_key         = try(var.primary_key, null)
  secondary_key       = try(var.secondary_key, null)
  state               = try(var.state, null)
  subscription_id     = try(var.subscription_id, null)
  allow_tracing       = try(var.allow_tracing, null)
}