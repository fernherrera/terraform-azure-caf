output "id" {
  description = "The ID of the VPN Site."
  value       = azurerm_vpn_site.vpn.id
}

output "link" {
  description = "One or more link blocks"
  value       = azurerm_vpn_site.vpn.link
}