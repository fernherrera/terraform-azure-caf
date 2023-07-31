output "id" {
  description = "The ID of the ExpressRoute Circuit Peering."
  value       = azurerm_express_route_circuit_peering.peering.id
}

output "azure_asn" {
  description = "The ASN used by Azure."
  value       = azurerm_express_route_circuit_peering.peering.azure_asn
}

output "primary_azure_port" {
  description = "The Primary Port used by Azure for this Peering."
  value       = azurerm_express_route_circuit_peering.peering.primary_azure_port
}

output "secondary_azure_port" {
  description = "The Secondary Port used by Azure for this Peering."
  value       = azurerm_express_route_circuit_peering.peering.secondary_azure_port
}