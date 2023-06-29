# Last reviewed :  AzureRM version 2.64.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group

#--------------------------------------
# Event Hub Consumer Group
#--------------------------------------
resource "azurerm_eventhub_consumer_group" "evhcg" {
  name                = var.name
  namespace_name      = var.namespace_name
  eventhub_name       = var.eventhub_name
  resource_group_name = var.resource_group_name
  user_metadata       = try(var.user_metadata, null)
}