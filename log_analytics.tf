module "log_analytics" {
  source   = "./modules/log_analytics"
  for_each = local.shared_services.log_analytics

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge({ "Name" = format("%s", each.value.name) }, lookup(each.value, "tags", {}), try(var.tags, {}), local.global_settings.tags, )

  daily_quota_gb                     = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled         = try(each.value.internet_ingestion_enabled, null)
  internet_query_enabled             = try(each.value.internet_query_enabled, null)
  reservation_capacity_in_gb_per_day = try(each.value.reservation_capacity_in_gb_per_day, null)
  sku                                = try(each.value.sku, "PerGB2018")
  retention_in_days                  = try(each.value.retention_in_days, 30)
}

output "log_analytics" {
  value     = module.log_analytics
  sensitive = true
}


module "log_analytics_diagnostics" {
  source   = "./modules/diagnostics"
  for_each = var.shared_services.log_analytics

  resource_id       = module.log_analytics[each.key].id
  resource_location = module.log_analytics[each.key].location
  diagnostics       = try(each.value.diagnostics, {})
  profiles          = try(each.value.diagnostic_profiles, {})
}

# module "log_analytics_storage_insights" {
#   source   = "./modules/monitoring/log_analytics_storage_insights"
#   for_each = local.shared_services.log_analytics_storage_insights

#   name                = each.value.name
#   settings            = try(each.value.settings, {})
#   resource_group_name = each.value.resource_group_name
#   workspace_id        = each.value.log_analytics.workspace_id
#   storage_account_id  = each.value.storage_account.id
#   primary_access_key  = each.value.storage_account.primary_access_key
#   /*
#   remote_objects = {
#     resource_group  = local.combined_objects_resource_groups
#     storage_account = local.combined_objects_storage_accounts
#     log_analytics   = local.combined_objects_log_analytics
#   }
# */
# }

# output "log_analytics_storage_insights" {
#   value = module.log_analytics_storage_insights
# }
