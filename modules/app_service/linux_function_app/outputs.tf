output "id" {
  description = "The ID of the Linux Function App."
  value       = azurerm_linux_function_app.function_app.id
}

output "custom_domain_vertification_id" {
  description = "The identifier used by App Service to perform domain ownership verification via DNS TXT record."
  value       = azurerm_linux_function_app.function_app.custom_domain_verification_id
}

output "default_hostname" {
  description = "The default hostname of the Linux Function App."
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "identity" {
  description = "The managed identity block from the Function app"
  value       = azurerm_linux_function_app.function_app.identity
}

output "kind" {
  description = "The Kind value for this Linux Function App."
  value       = azurerm_linux_function_app.function_app.kind
}

output "outbound_ip_address_list" {
  description = "A list of outbound IP addresses. For example [\"52.23.25.3\", \"52.143.43.12\"]"
  value       = azurerm_linux_function_app.function_app.outbound_ip_address_list
}

output "outbound_ip_addresses" {
  description = "A comma separated list of outbound IP addresses as a string. For example 52.23.25.3,52.143.43.12."
  value       = azurerm_linux_function_app.function_app.outbound_ip_addresses
}

output "possible_outbound_ip_address_list" {
  description = "A list of possible outbound IP addresses, not all of which are necessarily in use. This is a superset of outbound_ip_address_list. For example [\"52.23.25.3\", \"52.143.43.12\"]."
  value       = azurerm_linux_function_app.function_app.possible_outbound_ip_address_list
}

output "possible_outbound_ip_addresses" {
  description = "A comma separated list of possible outbound IP addresses as a string. For example 52.23.25.3,52.143.43.12,52.143.43.17. This is a superset of outbound_ip_addresses. For example [\"52.23.25.3\", \"52.143.43.12\", \"52.143.43.17\"]."
  value       = azurerm_linux_function_app.function_app.possible_outbound_ip_addresses
}

output "site_credential" {
  description = "The site credential block"
  value       = azurerm_linux_function_app.function_app.site_credential
}