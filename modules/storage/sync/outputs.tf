output "id" {
  description = "The ID of the Storage Sync"
  value       = azurerm_storage_sync.sync.id
}

output "sync_group_ids" {
  description = "List of Storage Sync Group ids."
  value       = [for g in azurerm_storage_sync_group.sync_group : g.id]
}

output "cloud_endpoint_ids" {
  description = "List of Storage Sync Cloud Endpoint ids."
  value       = [for c in azurerm_storage_sync_cloud_endpoint.cloud_endpoint : c.id]
}
