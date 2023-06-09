output "id" {
  description = "Express Route Circuit ID"
  value       = azurerm_express_route_circuit.circuit.id
}

output "service_provider_provisioning_state" {
  description = "The ExpressRoute circuit provisioning state from your chosen service provider."
  value       = azurerm_express_route_circuit.circuit.service_provider_provisioning_state
}

output "service_key" {
  description = "The string needed by the service provider to provision the ExpressRoute circuit."
  value       = azurerm_express_route_circuit.circuit.service_key
  sensitive   = true
}