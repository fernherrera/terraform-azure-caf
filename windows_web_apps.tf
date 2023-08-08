#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Default windows web app settings
  windows_web_app_settings_defaults = {
    https_only = true
    site_config = {
      application_stack = {
        current_stack  = "dotnetcore"
        dotnet_version = "v6.0"
      }
      always_on             = true
      ftps_state            = "Disabled"
      http2_enabled         = true
      managed_pipeline_mode = "Integrated"
      minimum_tls_version   = "1.2"
    }
  }

  # Managed identities
  windows_web_app_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.web.windows_web_apps : {
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

  # Default diagnostic settings
  windows_web_app_diagnostics_defaults = {
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
# Windows App Services
#----------------------------------------------------------
module "windows_web_apps" {
  source   = "./modules/app_service/windows_web_app"
  for_each = local.web.windows_web_apps

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  application_insight                 = try(each.value.application_insight_key, null) == null ? null : module.application_insights[each.value.application_insight_key]
  app_settings                        = try(each.value.app_settings, null)
  client_affinity_enabled             = try(each.value.client_affinity_enabled, null)
  client_certificate_enabled          = try(each.value.client_certificate_enabled, null)
  client_certificate_mode             = try(each.value.client_certificate_mode, null)
  connection_strings                  = try(each.value.connection_strings, {})
  enabled                             = try(each.value.enabled, null)
  https_only                          = try(each.value.https_only, null)
  identity                            = try(local.windows_web_app_managed_identities[each.key], null)
  key_vault_reference_identity_id     = try(each.value.key_vault_reference_identity_id, null)
  service_plan_id                     = can(each.value.app_service_plan_id) ? each.value.app_service_plan_id : module.app_service_plans[each.value.app_service_plan_key].id
  settings                            = merge(try(local.windows_web_app_settings_defaults, {}), try(each.value.settings, {}))
  storage_accounts                    = try(local.combined_objects.storage_accounts, null)
  zip_deploy_file                     = try(each.value.zip_deploy_file, null)
  virtual_network_integration_enabled = try(each.value.vnet_integration_enabled, false)
  virtual_network_subnet_id           = can(each.value.vnet_integration_enabled) && can(each.value.virtual_network_subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : module.virtual_subnets[each.value.vnet_key].subnets[each.value.subnet_key].id
}

#--------------------------------------
# Windows Web App Diagnostic settings
#--------------------------------------
module "windows_web_apps_diagnostics" {
  source   = "./modules/monitor/diagnostic_settings"
  for_each = local.web.windows_web_apps

  target_resource_id = module.windows_web_apps[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, null)

  name        = try(each.value.diagnostic_settings.name, local.windows_web_app_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.windows_web_app_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.windows_web_app_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.windows_web_app_diagnostics_defaults.metric, [])
}