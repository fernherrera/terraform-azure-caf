#----------------------------------------------------------
# API Management Product 
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


#----------------------------------------------------------
# API Management Product Policy
#----------------------------------------------------------
resource "azurerm_api_management_product_policy" "policy" {
  count               = try(var.policy, null) != null ? 1 : 0
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  product_id          = var.product_id

  xml_content = try(
    try(
      file("${path.root}/${var.policy.xml_file}"),
      var.policy.xml_content
    ),
    null
  )

  xml_link = try(var.policy.xml_link, null)
}