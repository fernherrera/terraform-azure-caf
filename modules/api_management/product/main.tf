#----------------------------------------------------------
# API Management Product Creation
#----------------------------------------------------------
resource "azurerm_api_management_product" "apim" {
  api_management_name   = var.api_management_name
  approval_required     = try(var.approval_required, null)
  description           = try(var.description, null)
  display_name          = var.display_name
  product_id            = var.product_id
  published             = var.published
  resource_group_name   = var.resource_group_name
  subscription_required = var.subscription_required
  subscriptions_limit   = try(var.subscriptions_limit, null)
}