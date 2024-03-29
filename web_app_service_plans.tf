#--------------------------------------
# Local declarations
#--------------------------------------
locals {
  service_plan_diagnostics_defaults = {
    name = "operational_metrics"
    metric = [
      {
        category = "AllMetrics"
        enabled  = true
      }
    ]
  }
}

#--------------------------------------
# App Service Plan 
#--------------------------------------
module "app_service_plans" {
  source   = "./modules/web/app_service_plan"
  for_each = local.web.app_service_plans

  name                = each.value.name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  os_type                      = each.value.os_type
  sku_name                     = each.value.sku_name
  app_service_environment_id   = try(each.value.app_service_environment_id, null)
  maximum_elastic_worker_count = try(each.value.maximum_elastic_worker_count, null)
  worker_count                 = try(each.value.worker_count, null)
  per_site_scaling_enabled     = try(each.value.per_site_scaling_enabled, false)
  zone_balancing_enabled       = try(each.value.zone_balancing_enabled, false)
}

#--------------------------------------
# App Service Plan  Diagnostic settings
#--------------------------------------
module "app_service_plan_diagnostics" {
  source = "./modules/monitor/diagnostic_settings"
  for_each = {
    for key, val in local.web.app_service_plans : key => val
    if try(val.diagnostic_settings, null) != null
  }

  target_resource_id = module.app_service_plans[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, module.event_hubs[each.value.diagnostic_settings.eventhub_key].name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, module.event_hub_namespace_auth_rules[each.value.diagnostic_settings.eventhub_authorization_rule_key].id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, module.log_analytics[each.value.diagnostic_settings.log_analytics_workspace_key].id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, module.storage_accounts[each.value.diagnostic_settings.storage_account_key].id, null)

  name        = try(each.value.diagnostic_settings.name, local.service_plan_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.service_plan_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.service_plan_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.service_plan_diagnostics_defaults.metric, [])
}