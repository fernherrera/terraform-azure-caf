output "id" {
  description = "The Microsoft SQL Server ID."
  value       = local.id
}

output "fully_qualified_domain_name" {
  description = "The fully qualified domain name of the Azure SQL Server (e.g. myServerName.database.windows.net)"
  value       = local.fully_qualified_domain_name
}

output "restorable_dropped_database_ids" {
  description = "A list of dropped restorable database IDs on the server."
  value       = local.restorable_dropped_database_ids
}