output "id" {
  description = "The ID of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.server.id
}

output "fqdn" {
  description = "The fully qualified domain name of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.server.fqdn
}

output "public_network_access_enabled" {
  description = "Is the public network access enabled?"
  value       = azurerm_mysql_flexible_server.server.public_network_access_enabled
}

output "replica_capacity" {
  description = "The maximum number of replicas that a primary MySQL Flexible Server can have."
  value       = azurerm_mysql_flexible_server.server.replica_capacity
}

output "name" {
  description = "The name of the MySQL Flexible Server."
  value       = azurerm_mysql_flexible_server.server.name
}