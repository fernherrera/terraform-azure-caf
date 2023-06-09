# module "diagnostics" {
#   source = "../../monitor/diagnostic_settings"

#   resource_id       = azurerm_key_vault.keyvault.id
#   resource_location = azurerm_key_vault.keyvault.location
#   diagnostics       = var.diagnostics
#   profiles          = try(var.settings.diagnostic_profiles, {})
# }