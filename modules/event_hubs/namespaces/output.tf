output "id" {
  description = "The EventHub Namespace ID."
  value       = azurerm_eventhub_namespace.evh.id
}

output "name" {
  description = "The EventHub Namespace name."
  value       = azurerm_eventhub_namespace.evh.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = local.resource_group_name
}

output "location" {
  description = "Location of the service"
  value       = local.location
}

output "tags" {
  description = "A mapping of tags to assign to the resource."
  value       = azurerm_eventhub_namespace.evh.tags
}

output "event_hubs" {
  value = module.event_hubs
}