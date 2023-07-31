output "id" {
  description = "The ID of the ExpressRoute Circuit Authorization."
  value       = azurerm_express_route_circuit_authorization.erc_authorization.id
}

output "authorization_key" {
  description = "The Authorization Key."
  value       = azurerm_express_route_circuit_authorization.erc_authorization.authorization_key
}

output "authorization_use_status" {
  description = "The authorization use status."
  value       = azurerm_express_route_circuit_authorization.erc_authorization.authorization_use_status
}