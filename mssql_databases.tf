module "mssql_databases" {
  source   = "./modules/databases/mssql_database"
  for_each = local.database.mssql_databases

  name = each.value.name
  tags = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  cloud               = local.cloud
  managed_identities  = local.combined_objects.managed_identities
  settings            = each.value
  server_id           = can(each.value.server_id) ? each.value.server_id : module.mssql_servers[each.value.mssql_server_key].id
  server_name         = can(each.value.server_name) ? each.value.server_name : module.mssql_servers[each.value.mssql_server_key].name
  elastic_pool_id     = can(each.value.elastic_pool_id) || can(each.value.elastic_pool_key) == false ? try(each.value.elastic_pool_id, null) : null #try(module.mssql_elastic_pools[each.value.elastic_pool_key].id, null)
  storage_accounts    = module.storage_accounts
  diagnostic_profiles = try(each.value.diagnostic_profiles, {})
  diagnostics         = local.combined_diagnostics
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
}

output "mssql_databases" {
  value = module.mssql_databases
}

# Database auditing
# data "azurerm_storage_account" "mssqldb_auditing" {
#   for_each = {
#     for key, value in local.database.mssql_databases : key => value
#     if try(value.extended_auditing_policy, null) != null
#   }

#   name                = module.storage_accounts[each.value.extended_auditing_policy.storage_account.key].name
#   resource_group_name = module.storage_accounts[each.value.extended_auditing_policy.storage_account.key].resource_group_name
# }

# resource "azurerm_mssql_server_extended_auditing_policy" "mssqldb" {
#   depends_on = [azurerm_role_assignment.for]
#   for_each = {
#     for key, value in local.database.mssql_databases : key => value
#     if try(value.extended_auditing_policy, null) != null
#   }

#   log_monitoring_enabled                  = try(each.value.extended_auditing_policy.log_monitoring_enabled, false)
#   server_id                               = module.mssql_servers[each.key].id
#   storage_endpoint                        = data.azurerm_storage_account.mssql_auditing[each.key].primary_blob_endpoint
#   storage_account_access_key              = data.azurerm_storage_account.mssql_auditing[each.key].primary_access_key
#   storage_account_access_key_is_secondary = false
#   retention_in_days                       = try(each.value.extended_auditing_policy.retention_in_days, null)
# }