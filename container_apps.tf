#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Managed identities
  container_app_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.web.linux_web_apps : {
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

  container_app_diagnostics_defaults = {
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
# Container Apps
#----------------------------------------------------------
module "container_apps" {
  source   = "./modules/containers/container_app"
  for_each = local.containers.container_app_environments

  depends_on = [module.container_app_environments]

  name                         = each.value.name
  resource_group_name          = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  container_app_environment_id = can(each.value.container_app_environment_id) ? each.value.container_app_environment_id : try(module.container_app_environments[each.value.container_app_environment_key].id, null)
  tags                         = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  revision_mode = each.value.revision_mode
  template      = each.value.template
  dapr          = try(each.value.dapr, {})
  identity      = try(local.container_app_managed_identities, {})
  ingress       = try(each.value.ingress, {})
  registry      = try(each.value.registry, {})
  secret        = try(each.value.secret, {})
}