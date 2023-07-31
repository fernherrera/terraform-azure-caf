output "id" {
  description = "The ID of the Storage Account"
  value       = local.id
}

output "name" {
  description = "The name of the Storage Account"
  value       = local.name
}

output "primary_blob_connection_string" {
  value     = try(local.primary_blob_connection_string, null)
  sensitive = true
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location."
  value       = local.primary_blob_endpoint
}

output "primary_access_key" {
  description = "The endpoint URL for blob storage in the primary location."
  value       = local.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  value     = try(local.primary_connection_string, null)
  sensitive = true
}

output "primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = local.primary_web_host
}

output "containers" {
  description = "The containers output objects as created by the container submodule."
  value       = module.container
}

output "queues" {
  description = "The queues output objects as created by the queues submodule."
  value       = module.queue
}

output "data_lake_filesystems" {
  description = "The data lake filesystem output objects as created by the data lake filesystem submodule."
  value       = module.data_lake_filesystem
}

output "file_share" {
  description = "The file shares output objects as created by the file shares submodule."
  value       = module.file_share
}