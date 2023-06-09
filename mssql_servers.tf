module "mssql_servers" {
  source = "./modules/databases/mssql_server"
  depends_on = [
    module.resource_groups,
    module.keyvault_access_policies,
    module.keyvault_access_policies_azuread_apps
  ]

  for_each = local.database.mssql_servers

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  settings          = each.value
  resource_groups   = module.resource_groups
  virtual_subnets   = module.virtual_subnets
  private_endpoints = try(each.value.private_endpoints, {})
  private_dns       = try(data.azurerm_private_dns_zone.dns, {})
  storage_accounts  = local.combined_objects.storage_accounts
  azuread_groups    = local.combined_objects.azuread_groups
  keyvault_id       = can(each.value.administrator_login_password) ? each.value.administrator_login_password : local.combined_objects.keyvaults[each.value.keyvault_key].id

  remote_objects = {
    keyvault_keys = local.combined_objects.keyvault_keys
  }
}

output "mssql_servers" {
  value = module.mssql_servers
}

# data "azurerm_storage_account" "mssql_auditing" {
#   for_each = {
#     for key, value in local.database.mssql_servers : key => value
#     if try(value.extended_auditing_policy, null) != null
#   }

#   name                = module.storage_accounts[each.value.extended_auditing_policy.storage_account.key].name
#   resource_group_name = module.storage_accounts[each.value.extended_auditing_policy.storage_account.key].resource_group_name
# }

# resource "azurerm_mssql_server_extended_auditing_policy" "mssql" {
#   depends_on = [azurerm_role_assignment.for]
#   for_each = {
#     for key, value in local.database.mssql_servers : key => value
#     if try(value.extended_auditing_policy, null) != null
#   }

#   log_monitoring_enabled                  = try(each.value.extended_auditing_policy.log_monitoring_enabled, false)
#   server_id                               = module.mssql_servers[each.key].id
#   storage_endpoint                        = data.azurerm_storage_account.mssql_auditing[each.key].primary_blob_endpoint
#   storage_account_access_key              = data.azurerm_storage_account.mssql_auditing[each.key].primary_access_key
#   storage_account_access_key_is_secondary = false
#   retention_in_days                       = try(each.value.extended_auditing_policy.retention_in_days, null)
# }

# module "mssql_failover_groups" {
#   source   = "./modules/databases/mssql_server/failover_group"
#   for_each = local.database.mssql_failover_groups

#   name                = each.value.name
#   settings            = each.value.settings
#   resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects.resource_groups[try(each.value.resource_group_key, each.value.resource_group.key)].name
#   primary_server_name = module.mssql_servers[each.value.primary_server.sql_server_key].name
#   secondary_server_id = module.mssql_servers[each.value.secondary_server.sql_server_key].id
#   databases           = local.combined_objects.mssql_databases
# }