output "redis_cache_instance_id" {
  description = "Redis Cache Instance ID"
  value       = azurerm_redis_cache.main.id
}

output "redis_cache_instance_name" {
  description = "Redis Cache Instance name"
  value       = azurerm_redis_cache.main.name
}

output "redis_cache_hostname" {
  description = "The Hostname of the Redis Instance"
  value       = azurerm_redis_cache.main.hostname
}

output "redis_cache_ssl_port" {
  description = "The SSL Port of the Redis Instance"
  value       = azurerm_redis_cache.main.ssl_port
}

output "redis_cache_port" {
  description = "The non-SSL Port of the Redis Instance"
  value       = azurerm_redis_cache.main.port
  sensitive   = true
}

output "redis_cache_primary_access_key" {
  description = "The Primary Access Key for the Redis Instance"
  value       = azurerm_redis_cache.main.primary_access_key
  sensitive   = true
}

output "redis_cache_secondary_access_key" {
  description = "The Secondary Access Key for the Redis Instance"
  value       = azurerm_redis_cache.main.secondary_access_key
  sensitive   = true
}

output "redis_cache_primary_connection_string" {
  description = "The primary connection string of the Redis Instance."
  value       = azurerm_redis_cache.main.primary_connection_string
  sensitive   = true
}

output "redis_cache_secondary_connection_string" {
  description = "The secondary connection string of the Redis Instance."
  value       = azurerm_redis_cache.main.secondary_connection_string
  sensitive   = true
}

output "redis_configuration_maxclients" {
  description = "Returns the max number of connected clients at the same time."
  value       = azurerm_redis_cache.main.redis_configuration.0.maxclients
}

output "redis_cache_private_endpoint" {
  description = "id of the Redis Cache server Private Endpoint"
  value       = var.enable_private_endpoint ? element(concat(azurerm_private_endpoint.pep1.*.id, [""]), 0) : null
}

output "redis_cache_private_dns_zone_domain" {
  description = "DNS zone name of Redis Cache server Private endpoints dns name records"
  value       = var.existing_private_dns_zone == null && var.enable_private_endpoint ? element(concat(azurerm_private_dns_zone.dnszone1.*.name, [""]), 0) : var.existing_private_dns_zone
}

output "redis_cache_private_endpoint_ip" {
  description = "Redis Cache server private endpoint IPv4 Addresses"
  value       = var.enable_private_endpoint ? element(concat(data.azurerm_private_endpoint_connection.private-ip1.*.private_service_connection.0.private_ip_address, [""]), 0) : null
}

output "redis_cache_private_endpoint_fqdn" {
  description = "Redis Cache server private endpoint FQDN Addresses"
  value       = var.enable_private_endpoint ? element(concat(azurerm_private_dns_a_record.arecord1.*.fqdn, [""]), 0) : null
}