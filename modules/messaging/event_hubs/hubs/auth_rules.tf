module "authorization_rules" {
  source   = "./auth_rules"
  for_each = try(var.auth_rules, {})

  name                = each.value.each.name
  namespace_name      = var.namespace_name
  eventhub_name       = azurerm_eventhub.evhub.name
  resource_group_name = var.resource_group_name
  listen              = try(each.value.listen, false)
  send                = try(each.value.send, false)
  manage              = try(each.value.manage, false)
}