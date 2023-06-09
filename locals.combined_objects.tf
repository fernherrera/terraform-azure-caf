#-----------------------------------------------------------------------------
# Landing zones can retrieve remote objects from a different landing zone 
# and the combined_objects will merge it with the local objects.
#-----------------------------------------------------------------------------
locals {
  combined_objects = {
    api_management                    = merge(try(module.api_management, {}), try(data.azurerm_api_management.apim, {}))
    azuread_apps                      = {}
    azuread_groups                    = {}
    azuread_service_principals        = {}
    diagnostic_storage_accounts       = {}
    keyvaults                         = merge(try(module.keyvaults, {}), try(data.azurerm_key_vault.kv, {}))
    keyvault_keys                     = {}
    log_analytics                     = merge(try(module.log_analytics, {}), try(data.azurerm_log_analytics_workspace.law, {}))
    managed_identities                = {}
    mssql_managed_instances           = {}
    mssql_managed_instances_secondary = {}
    private_dns                       = try(data.azurerm_private_dns_zone.dns, {})
    resource_groups                   = merge(try(module.resource_groups, {}), {})
    storage_accounts                  = merge(try(module.storage_accounts, {}), try(data.azurerm_storage_account.stg, {}))
  }
}