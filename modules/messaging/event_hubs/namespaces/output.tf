output "id" {
  description = "The EventHub Namespace ID."
  value       = local.id
}

output "event_hubs" {
  value = module.event_hubs
}