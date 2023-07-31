output "id" {
  description = "The EventHub Namespace ID."
  value       = azurerm_eventhub_namespace.evh.id
}

output "event_hubs" {
  value = module.event_hubs
}