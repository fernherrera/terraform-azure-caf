output "id" {
  value = local.id
}

output "primary_shared_key" {
  value     = local.primary_shared_key
  sensitive = true
}

output "secondary_shared_key" {
  value     = local.secondary_shared_key
  sensitive = true
}

output "workspace_id" {
  value = local.workspace_id
}