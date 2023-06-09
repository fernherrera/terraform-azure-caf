# Last reviewed :  AzureRM version 2.64.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule

#--------------------------------------
# Event Hub Authorization Rule
#--------------------------------------
resource "azurerm_eventhub_authorization_rule" "evhub_rule" {
  name                = var.name
  namespace_name      = var.namespace_name
  eventhub_name       = var.eventhub_name
  resource_group_name = var.resource_group_name
  listen              = try(var.listen, false)
  send                = try(var.send, false)
  manage              = try(var.manage, false)
}