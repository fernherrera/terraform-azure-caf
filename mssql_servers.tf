#---------------------------------
# Local declarations
#---------------------------------
locals {
  mssql_servers_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.database.mssql_servers : {
          sa_key = sa_key
          type   = try(sa.identity.type, "SystemAssigned")
          managed_identities = concat(
            try(sa.identity.managed_identity_ids, []),
            flatten([
              for managed_identity_key in try(sa.identity.managed_identity_keys, []) : [
                module.managed_identities[managed_identity_key].id
              ]
            ])
          )
        } if try(sa.identity, null) != null
      ]
    ) : format("%s", managed_identity.sa_key) => managed_identity
  }

  mssql_servers_private_endpoints = {
    for private_endpoint in
    flatten(
      [
        for ms_key, ms in local.database.mssql_servers : [
          for pe_key, pe in try(ms.private_endpoints, {}) : {
            ms_key              = ms_key
            pe_key              = pe_key
            id                  = module.mssql_servers[ms_key].id
            resource_group_name = module.resource_groups[pe.resource_group_key].name
            location            = module.resource_groups[pe.resource_group_key].location
            tags                = module.mssql_servers[ms_key].tags
            name                = try(pe.name, "")
            subnet_id           = try(pe.vnet_key, null) == null ? null : try(module.virtual_subnets[pe.vnet_key].subnets[pe.subnet_key].id)
            private_service_connection = merge(try(pe.private_service_connection, {}), {
              private_connection_resource_id = module.mssql_servers[ms_key].id
            })
          }
        ]
      ]
    ) : format("%s-%s", private_endpoint.ms_key, private_endpoint.pe_key) => private_endpoint
  }
}

#--------------------------------------
# MSSQL Servers
#--------------------------------------
module "mssql_servers" {
  source   = "./modules/databases/mssql_server"
  for_each = local.database.mssql_servers

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  server_version                               = each.value.server_version
  administrator_login                          = try(each.value.administrator_login, null)
  administrator_login_password                 = try(each.value.administrator_login_password, null)
  azuread_administrator                        = try(each.value.azuread_administrator, {})
  azuread_groups                               = local.combined_objects.azuread_groups
  connection_policy                            = try(each.value.connection_policy, null)
  firewall_rules                               = try(each.value.firewall_rules, {})
  identity                                     = try(local.mssql_servers_managed_identities[each.key], null)
  minimum_tls_version                          = try(each.value.minimum_tls_version, null)
  outbound_network_restriction_enabled         = try(each.value.outbound_network_restriction_enabled, false)
  primary_user_assigned_identity_id            = try(each.value.primary_user_assigned_identity_id, null)
  public_network_access_enabled                = try(each.value.public_network_access_enabled, true)
  transparent_data_encryption_key_vault_key_id = try(each.value.transparent_data_encryption_key_vault_key_id, null)
  virtual_networks                             = module.virtual_subnets
  virtual_network_rules                        = try(each.value.virtual_network_rules, {})

  private_endpoints = try(each.value.private_endpoints, {})
  private_dns       = try(data.azurerm_private_dns_zone.dns, {})
  # storage_accounts  = local.combined_objects.storage_accounts
  # keyvault_id       = can(each.value.administrator_login_password) ? each.value.administrator_login_password : local.combined_objects.keyvaults[each.value.keyvault_key].id

  # remote_objects = {
  #   keyvault_keys = local.combined_objects.keyvault_keys
  # }
}

#--------------------------------------
# MSSQL Servers Private Endpoints
#--------------------------------------
module "mssql_servers_private_endpoints" {
  source   = "./modules/networking/private_endpoint"
  for_each = local.mssql_servers_private_endpoints

  depends_on = [module.mssql_servers]

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tags                          = each.value.tags
  subnet_id                     = each.value.subnet_id
  private_service_connection    = each.value.private_service_connection
  private_dns_zone_group        = try(each.value.private_dns_zone_group, {})
  custom_network_interface_name = try(each.value.custom_network_interface_name, null)
  ip_configuration              = try(each.value.ip_configuration, [])
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