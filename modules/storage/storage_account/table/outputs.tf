output "name" {
  description = "The name of the Storage Table."
  value       = azurerm_storage_table.table.name
}

output "id" {
  description = "The ID of the Storage Table."
  value       = azurerm_storage_table.table.id
}