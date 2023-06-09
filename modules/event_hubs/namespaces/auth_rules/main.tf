#--------------------------------------
# Event Hub Namespace Authorization Rules
#--------------------------------------
resource "azurerm_eventhub_namespace_authorization_rule" "evh_ns_rule" {
  name                = var.name
  namespace_name      = var.namespace_name
  resource_group_name = var.resource_group_name
  listen              = try(var.listen, false)
  send                = try(var.send, false)
  manage              = try(var.manage, false)
}