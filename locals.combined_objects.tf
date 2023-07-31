#-----------------------------------------------------------------------------
# Landing zones can retrieve remote objects from a different landing zone 
# and the combined_objects will merge it with the local objects.
#-----------------------------------------------------------------------------
locals {
  combined_objects = {
    api_management                    = try(module.api_management, {})
    azuread_apps                      = {}
    azuread_groups                    = {}
    azuread_service_principals        = {}
    diagnostic_storage_accounts       = {}
    keyvaults                         = try(module.keyvaults, {})
    keyvault_keys                     = {}
    log_analytics                     = try(module.log_analytics, {})
    managed_identities                = {}
    mssql_servers                     = {}
    mssql_managed_instances           = {}
    mssql_managed_instances_secondary = {}
    private_dns                       = merge(try(module.private_dns, {}), try(data.azurerm_private_dns_zone.dns, {}))
    resource_groups                   = try(module.resource_groups, {})
    storage_accounts                  = try(module.storage_accounts, {})
  }
}