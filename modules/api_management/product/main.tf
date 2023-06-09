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
# API Management Product Creation
#----------------------------------------------------------
resource "azurerm_api_management_product" "apim" {
  api_management_name   = local.api_management_name
  resource_group_name   = local.resource_group_name
  product_id            = var.product_id
  display_name          = var.display_name
  description           = try(var.description, null)
  approval_required     = try(var.approval_required, null)
  subscription_required = var.subscription_required
  subscriptions_limit   = try(var.subscriptions_limit, null)
  published             = var.published
}