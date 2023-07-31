#----------------------------------------------------------
# Static Site
#----------------------------------------------------------
resource "azurerm_static_site" "static_site" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  sku_tier            = try(var.sku_tier, "Free")
  sku_size            = try(var.sku_size, "Free")

  dynamic "identity" {
    for_each = can(var.identity) ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = concat(identity.value.managed_identities, [])
    }
  }
}

#----------------------------------------------------------
# Static Site Custom Domain
#----------------------------------------------------------
resource "azurerm_static_site_custom_domain" "custom_domains" {
  for_each = try(var.custom_domains, {})

  static_site_id  = azurerm_static_site.static_site.id
  domain_name     = each.value.domain_name
  validation_type = try(each.value.validation_type, null)
}