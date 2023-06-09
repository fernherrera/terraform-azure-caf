module "storage_syncs" {
  source   = "./modules/storage/sync"
  for_each = local.storage.storage_syncs

  depends_on = [module.storage_accounts]

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  incoming_traffic_policy = try(each.value.incoming_traffic_policy, null)
  sync_groups             = try(each.value.sync_groups, [])
  cloud_endpoints         = try(each.value.cloud_endpoints, {})
  storage_accounts        = try(module.storage_accounts, {})
}

output "storage_syncs" {
  value = module.storage_syncs
}