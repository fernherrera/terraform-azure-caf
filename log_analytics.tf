#----------------------------------------------------------
# Local declarations
#----------------------------------------------------------
locals {
  log_analytics_diagnostics_defaults = {
    name = "operational_logs_and_metrics"
    enabled_log = [
      {
        category = "Audit"
        enabled  = true
      },
    ]
    metric = [
      {
        category = "AllMetrics"
        enabled  = true
      }
    ]
  }
}

#----------------------------------------------------------
# Log Analytics Workspace
#----------------------------------------------------------
module "log_analytics" {
  source   = "./modules/log_analytics"
  for_each = local.shared_services.log_analytics

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  existing            = try(each.value.existing, false)
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  diagnostic_settings                = try(each.value.diagnostic_settings, {})
  daily_quota_gb                     = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled         = try(each.value.internet_ingestion_enabled, null)
  internet_query_enabled             = try(each.value.internet_query_enabled, null)
  reservation_capacity_in_gb_per_day = try(each.value.reservation_capacity_in_gb_per_day, null)
  sku                                = try(each.value.sku, "PerGB2018")
  retention_in_days                  = try(each.value.retention_in_days, 30)
}


#----------------------------------------------------------
# Log Analytics Workspace Diagnostic Setting
#----------------------------------------------------------
module "log_analytics_diagnostics" {
  source = "./modules/monitor/diagnostic_settings"
  for_each = {
    for key, val in local.shared_services.log_analytics : key => val
    if try(val.diagnostic_settings, null) != null
  }

  target_resource_id = module.log_analytics[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, module.event_hubs[each.value.diagnostic_settings.eventhub_key].name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, module.event_hub_namespace_auth_rules[each.value.diagnostic_settings.eventhub_authorization_rule_key].id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, module.log_analytics[each.value.diagnostic_settings.log_analytics_workspace_key].id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, module.storage_accounts[each.value.diagnostic_settings.storage_account_key].id, null)

  name        = try(each.value.diagnostic_settings.name, local.log_analytics_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.log_analytics_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.log_analytics_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.log_analytics_diagnostics_defaults.metric, [])
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
#     resource_group  = module.resource_groups
#     storage_account = module.storage_accounts
#     log_analytics   = module.log_analytics
#   }
# */
# }
