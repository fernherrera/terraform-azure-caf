#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Managed identities
  windows_function_app_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.web.function_apps_windows : {
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

  # Default windows function app settings
  windows_function_app_settings_defaults = {
    site_config = {
      always_on = false
      application_stack = {
        dotnet_version = "v6.0"
      }
      use_32_bit_worker = false
    }
  }

  windows_function_app_diagnostics_defaults = {
    name = "operational_logs_and_metrics"
    enabled_log = [
      {
        category = "FunctionAppLogs"
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
# Windows App Functions
#----------------------------------------------------------
module "windows_function_apps" {
  source   = "./modules/web/function_app_windows"
  for_each = local.web.function_apps_windows

  name                = each.value.name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  service_plan_id                     = can(each.value.app_service_plan_id) ? each.value.app_service_plan_id : module.app_service_plans[each.value.app_service_plan_key].id
  app_settings                        = try(each.value.app_settings, null)
  builtin_logging_enabled             = try(each.value.builtin_logging_enabled, null)
  client_certificate_enabled          = try(each.value.client_certificate_enabled, null)
  client_certificate_mode             = try(each.value.client_certificate_mode, null)
  client_certificate_exclusion_paths  = try(each.value.client_certificate_exclusion_paths, null)
  connection_strings                  = try(each.value.connection_strings, {})
  content_share_force_disabled        = try(each.value.content_share_force_disabled, null)
  daily_memory_time_quota             = try(each.value.daily_memory_time_quota, 0)
  enabled                             = try(each.value.enabled, null)
  functions_extension_version         = try(each.value.functions_extension_version, null)
  https_only                          = try(each.value.https_only, null)
  identity                            = try(local.windows_function_app_managed_identities[each.key], null)
  key_vault_reference_identity_id     = try(each.value.key_vault_reference_identity_id, null)
  settings                            = merge(try(local.windows_function_app_settings_defaults, {}), try(each.value.settings, {}))
  storage_account_access_key          = can(each.value.storage_account_access_key) ? each.value.storage_account_access_key : module.storage_accounts[each.value.storage_account_key].primary_access_key
  storage_account_name                = can(each.value.storage_account_name) ? each.value.storage_account_name : module.storage_accounts[each.value.storage_account_key].name
  storage_uses_managed_identity       = try(each.value.storage_uses_managed_identity, null)
  storage_key_vault_secret_id         = try(each.value.storage_key_vault_secret_id, null)
  virtual_network_integration_enabled = try(each.value.vnet_integration_enabled, false)
  virtual_network_subnet_id           = can(each.value.vnet_integration_enabled) && can(each.value.virtual_network_subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : module.virtual_subnets[each.value.vnet_key].subnets[each.value.subnet_key].id
  application_insight                 = try(each.value.application_insight_key, null) == null ? null : module.application_insights[each.value.application_insight_key]
}

#--------------------------------------
# Windows App Function Diagnostic settings
#--------------------------------------
module "windows_function_apps_diagnostics" {
  source = "./modules/monitor/diagnostic_settings"
  for_each = {
    for key, val in local.web.function_apps_windows : key => val
    if try(val.diagnostic_settings, null) != null
  }

  target_resource_id = module.windows_function_apps[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, module.event_hubs[each.value.diagnostic_settings.eventhub_key].name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, module.event_hub_namespace_auth_rules[each.value.diagnostic_settings.eventhub_authorization_rule_key].id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, module.log_analytics[each.value.diagnostic_settings.log_analytics_workspace_key].id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, module.storage_accounts[each.value.diagnostic_settings.storage_account_key].id, null)

  name        = try(each.value.diagnostic_settings.name, local.linux_function_app_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.linux_function_app_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.linux_function_app_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.linux_function_app_diagnostics_defaults.metric, [])
}
