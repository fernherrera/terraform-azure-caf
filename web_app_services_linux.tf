#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Default linux web app settings
  linux_web_app_settings_defaults = {
    site_config = {
      application_stack = {
        php_version = "8.1"
      }
      ftps_state = "Disabled"
    }
  }

  # Managed identities
  linux_web_app_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.web.app_services_linux : {
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

  linux_web_app_diagnostics_defaults = {
    name = "operational_logs_and_metrics"
    log = [
      {
        name    = "AppServiceHTTPLogs"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "AppServiceConsoleLogs"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "AppServiceAppLogs"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "AppServiceAuditLogs"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "AppServiceIPSecAuditLogs"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "AppServicePlatformLogs"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
    ]
    metric = [
      {
        name    = "AllMetrics"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      }
    ]
  }
}


#----------------------------------------------------------
# Linux Web App Services
#----------------------------------------------------------
module "linux_web_apps" {
  source   = "./modules/web/app_service_linux"
  for_each = local.web.app_services_linux

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  application_insight                 = try(each.value.application_insight_key, null) == null ? null : module.application_insights[each.value.application_insight_key]
  app_settings                        = try(each.value.app_settings, null)
  client_affinity_enabled             = try(each.value.client_affinity_enabled, null)
  client_certificate_enabled          = try(each.value.client_certificate_enabled, null)
  client_certificate_mode             = try(each.value.client_certificate_mode, null)
  client_certificate_exclusion_paths  = try(each.value.client_certificate_exclusion_paths, null)
  connection_strings                  = try(each.value.connection_strings, {})
  enabled                             = try(each.value.enabled, null)
  https_only                          = try(each.value.https_only, null)
  identity                            = try(local.linux_web_app_managed_identities[each.key], null)
  key_vault_reference_identity_id     = try(each.value.key_vault_reference_identity_id, null)
  service_plan_id                     = can(each.value.app_service_plan_id) ? each.value.app_service_plan_id : module.app_service_plans[each.value.app_service_plan_key].id
  settings                            = merge(try(local.linux_web_app_settings_defaults, {}), try(each.value.settings, {}))
  storage_accounts                    = try(module.storage_accounts, null)
  zip_deploy_file                     = try(each.value.zip_deploy_file, null)
  virtual_network_integration_enabled = try(each.value.vnet_integration_enabled, false)
  virtual_network_subnet_id           = can(each.value.vnet_integration_enabled) && can(each.value.virtual_network_subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : module.virtual_subnets[each.value.vnet_key].subnets[each.value.subnet_key].id
}

#--------------------------------------
# Linux Web App Diagnostic settings
#--------------------------------------
module "linux_web_apps_diagnostics" {
  source   = "./modules/monitor/diagnostic_settings"
  for_each = local.web.app_services_linux

  target_resource_id = module.linux_web_apps[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, null)

  name        = try(each.value.diagnostic_settings.name, local.linux_web_app_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.linux_web_app_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.linux_web_app_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.linux_web_app_diagnostics_defaults.metric, [])
}
