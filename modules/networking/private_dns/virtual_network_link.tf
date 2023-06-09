
#----------------------------------------------------------
# Virtual network links
#----------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.vnet_links

  name                  = try(lower("${each.value.name}-link"), "${var.vnets.vnets[each.value.vnet_key].name}-link", lower("${azurerm_private_dns_zone.private_dns.name}-link"))
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = try(each.value.virtual_network_id, var.vnets.vnets[each.value.vnet_key].id, null)
  registration_enabled  = try(each.value.registration_enabled, false)
  tags                  = merge(local.tags, try(each.value.tags, null))
}