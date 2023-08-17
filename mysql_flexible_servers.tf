#---------------------------------
# Local declarations
#---------------------------------
locals {
  mysql_flexible_servers_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.database.mysql_flexible_servers : {
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

  mysql_flexible_servers_private_endpoints = {
    for private_endpoint in
    flatten(
      [
        for ms_key, ms in local.database.mysql_flexible_servers : [
          for pe_key, pe in try(ms.private_endpoints, {}) : {
            ms_key              = ms_key
            pe_key              = pe_key
            id                  = module.mysql_servers[ms_key].id
            resource_group_name = module.resource_groups[pe.resource_group_key].name
            location            = module.resource_groups[pe.resource_group_key].location
            tags                = module.mysql_servers[ms_key].tags
            name                = try(pe.name, "")
            subnet_id           = try(pe.vnet_key, null) == null ? null : try(module.virtual_subnets[pe.vnet_key].subnets[pe.subnet_key].id)
            private_service_connection = merge(try(pe.private_service_connection, {}), {
              private_connection_resource_id = module.mysql_servers[ms_key].id
            })
          }
        ]
      ]
    ) : format("%s-%s", private_endpoint.ms_key, private_endpoint.pe_key) => private_endpoint
  }
}

#--------------------------------------
# MySQL Flexible Servers
#--------------------------------------
module "mysql_servers" {
  source   = "./modules/databases/mysql_flexible_server"
  for_each = local.database.mysql_flexible_servers

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  administrator_login               = try(each.value.administrator_login, null)
  administrator_password            = try(each.value.administrator_password, null)
  backup_retention_days             = try(each.value.backup_retention_days, 7)
  create_mode                       = try(each.value.create_mode, "Default")
  customer_managed_key              = try(each.value.customer_managed_key, {})
  delegated_subnet_id               = try(each.value.delegated_subnet_id, null)
  geo_redundant_backup_enabled      = try(each.value.geo_redundant_backup_enabled, false)
  high_availability                 = try(each.value.high_availability, {})
  identity                          = try(local.mysql_flexible_servers_managed_identities[each.key], null)
  maintenance_window                = try(each.value.maintenance_window, {})
  private_dns_zone_id               = try(each.value.private_dns_zone_id, null)
  replication_role                  = try(each.value.replication_role, null)
  sku_name                          = try(each.value.sku_name, null)
  source_server_id                  = try(each.value.source_server_id, null)
  storage                           = try(each.value.storage, {})
  point_in_time_restore_time_in_utc = try(each.value.point_in_time_restore_time_in_utc, null)
  mysql_version                     = try(each.value.mysql_version, "5.7")
  zone                              = try(each.value.zone, null)
  firewall_rules                    = try(each.value.firewall_rules, [])

  # resource_groups = module.resource_groups
  # virtual_subnets = module.virtual_subnets
  # private_endpoints = try(each.value.private_endpoints, {})
  //private_dns       = local.combined_objects.private_dns
  //storage_accounts = module.storage_accounts
}
