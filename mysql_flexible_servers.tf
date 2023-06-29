module "mysql_servers" {
  source   = "./modules/databases/mysql_flexible_server"
  for_each = local.database.mysql_flexible_servers

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  administrator_login               = try(each.value.administrator_login, null)
  administrator_password            = try(each.value.administrator_password, null)
  backup_retention_days             = try(each.value.backup_retention_days, 7)
  create_mode                       = try(each.value.create_mode, "Default")
  customer_managed_key              = try(each.value.customer_managed_key, {})
  delegated_subnet_id               = try(each.value.delegated_subnet_id, null)
  geo_redundant_backup_enabled      = try(each.value.geo_redundant_backup_enabled, false)
  high_availability                 = try(each.value.high_availability, {})
  identity                          = try(each.value.identity, {})
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
  //private_dns       = try(data.azurerm_private_dns_zone.dns, {})
  //storage_accounts = local.combined_objects.storage_accounts
}

output "mysql_servers" {
  value = module.mysql_servers
}