output "id" {
  description = "The ID of this Front Door Profile."
  value       = azurerm_cdn_frontdoor_profile.fd.id
}

output "resource_guid" {
  description = "The UUID of this Front Door Profile which will be sent in the HTTP Header as the X-Azure-FDID attribute."
  value       = azurerm_cdn_frontdoor_profile.fd.resource_guid
}

output "endpoints" {
  description = "Front Door Endpoints."
  value       = azurerm_cdn_frontdoor_endpoint.ep
}

output "origin_groups" {
  description = "Front Door Origin Groups"
  value       = azurerm_cdn_frontdoor_origin_group.orggrp
}

output "routes" {
  description = "Front Door Routes"
  value       = azurerm_cdn_frontdoor_route.rt
}

output "custom_domains" {
  description = "Front Door Custom Domains"
  value       = azurerm_cdn_frontdoor_custom_domain.domains
}