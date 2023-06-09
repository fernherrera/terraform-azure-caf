# module "diagnostics" {
#   source = "../../monitor/diagnostic_settings"
#   count  = var.diagnostic_profiles == null ? 0 : 1

#   resource_id       = azurerm_data_factory.df.id
#   resource_location = local.location
#   diagnostics       = var.diagnostics
#   profiles          = var.diagnostic_profiles
# }