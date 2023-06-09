
#--------------------------------------
# Private DNS
#--------------------------------------
data "azurerm_private_dns_zone" "dns" {
  provider = azurerm.prd_ent
  for_each = try(var.remote_objects.private_dns, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}