output "policy_definition_id" {
  description = "Azure policy ID"
  value       = var.custom_policy ? element(concat(azurerm_policy_definition.policy.0.id, [""]), 0) : var.policy_definition_id
}