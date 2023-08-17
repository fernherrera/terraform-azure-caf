output "id" {
  value = azurerm_service_plan.asp.id
}

output "kind" {
  value = azurerm_service_plan.asp.kind
}

output "reserved" {
  value = azurerm_service_plan.asp.reserved
}

output "ase_id" {
  value = var.app_service_environment_id
}