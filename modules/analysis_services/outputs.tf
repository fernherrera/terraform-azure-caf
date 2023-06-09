output "id" {
  description = "The ID of the Analysis Services Server."
  value       = azurerm_analysis_services_server.server.id
}

output "server_full_name" {
  description = "The full name of the Analysis Services Server."
  value       = azurerm_analysis_services_server.server.server_full_name
}