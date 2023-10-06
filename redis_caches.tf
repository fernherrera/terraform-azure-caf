#--------------------------------------
# Azure Cache for Redis
#--------------------------------------
module "redis_cache" {
  source   = "./modules/databases/redis_cache"
  for_each = local.database.redis_caches

  create_resource_group = try(each.value.create_resource_group, false)
  resource_group_name   = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  location              = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                  = merge(try(each.value.tags, {}), local.global_settings.tags)

  name                                       = each.value.name
  log_analytics_workspace_name               = try(each.value.log_analytics_workspace_name, null)
  capacity                                   = try(each.value.capacity, 1)
  sku_name                                   = try(each.value.sku_name, "Basic")
  shard_count                                = try(each.value.shard_count, 1)
  replicas_per_master                        = try(each.value.replicas_per_master, 1)
  minimum_tls_version                        = try(each.value.minimum_tls_version, "1.2")
  enable_non_ssl_port                        = try(each.value.enable_non_ssl_port, false)
  public_network_access_enabled              = try(each.value.public_network_access_enabled, true)
  private_static_ip_address                  = try(each.value.private_static_ip_address, null)
  subnet_id                                  = try(each.value.subnet_id, null)
  zones                                      = try(each.value.zones, null)
  redis_version                              = try(each.value.redis_version, 6)
  redis_configuration                        = try(each.value.redis_configuration, {})
  patch_schedule                             = try(each.value.patch_schedule, null)
  storage_account_name                       = try(each.value.storage_account_name, null)
  data_persistence_enabled                   = try(each.value.data_persistence_enabled, false)
  data_persistence_backup_frequency          = try(each.value.data_persistence_backup_frequency, 60)
  data_persistence_backup_max_snapshot_count = try(each.value.data_persistence_backup_max_snapshot_count, 1)
  firewall_rules                             = try(each.value.firewall_rules, null)
  enable_private_endpoint                    = try(each.value.enable_private_endpoint, false)
  virtual_network_name                       = try(each.value.virtual_network_name, "")
  existing_private_dns_zone                  = try(each.value.existing_private_dns_zone, null)
  private_subnet_address_prefix              = try(each.value.private_subnet_address_prefix, null)
}