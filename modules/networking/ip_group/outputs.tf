output "id" {
  description = "The ID of the IP group."
  value       = azurerm_ip_group.ipgrp.id
}

output "firewall_ids" {
  description = "A firewall_ids block."
  value       = azurerm_ip_group.ipgrp.firewall_ids
}

output "firewall_policy_ids" {
  description = "A firewall_policy_ids block."
  value       = azurerm_ip_group.ipgrp.firewall_policy_ids
}