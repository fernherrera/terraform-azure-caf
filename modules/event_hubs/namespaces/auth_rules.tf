module "event_hub_namespace_auth_rules" {
  source   = "./auth_rules"
  for_each = try(var.auth_rules, {})

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.evh.name
  resource_group_name = local.resource_group_name
  listen              = try(each.value.listen, false)
  send                = try(each.value.send, false)
  manage              = try(each.value.manage, false)
}