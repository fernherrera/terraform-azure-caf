#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Certificates
  container_app_environment_certificates = {
    for cae_certificates in
    flatten([
      for cae_key, cae in local.containers.container_app_environments : [
        for cert_key, cert in try(cae.certificates, {}) : {
          cae_key                      = cae_key
          cert_key                     = cert_key
          name                         = cert.name
          container_app_environment_id = module.container_app_environments[cae_key].id
          certificate_blob_base64      = cert.certificate_blob_base64
          certificate_password         = cert.certificate_password
          tags                         = try(module.container_app_environments[cae_key].tags, {})
        }
      ]
    ]) : format("%s-%s", cae_certificates.cae_key, cae_certificates.cert_key) => cae_certificates
  }

  # Dapr Components
  container_app_environment_dapr_components = {
    for dapr_components in
    flatten([
      for cae_key, cae in local.containers.container_app_environments : [
        for dapr_key, dapr in try(cae.dapr_components, {}) : {
          cae_key                      = cae_key
          dapr_key                     = dapr_key
          container_app_environment_id = module.container_app_environments[cae_key].id
          name                         = dapr.name
          type                         = dapr.type
          version                      = dapr.version
          ignore_errors                = try(dapr.ignore_errors, null)
          init_timeout                 = try(dapr.init_timeout, null)
          metadata                     = try(dapr.metadata, null)
          scopes                       = try(dapr.scopes, null)
          secret                       = try(dapr.secret, null)
        }
      ]
    ]) : format("%s-%s", dapr_components.cae_key, dapr_components.dapr_key) => dapr_components
  }

  # Storage
  container_app_environment_storage = {
    for storage in
    flatten([
      for cae_key, cae in local.containers.container_app_environments : [
        for sa_key, sa in try(cae.storage, {}) : {
          cae_key                      = cae_key
          sa_key                       = sa_key
          container_app_environment_id = module.container_app_environments[cae_key].id
          name                         = sa.name
          account_name                 = try(sa.account_name, module.storage_accounts[sa.account_key].name)
          access_key                   = try(sa.account_name, module.storage_accounts[sa.account_key].primary_access_key)
          share_name                   = sa.share_name
          access_mode                  = try(sa.access_mode, "ReadOnly")
        }
      ]
    ]) : format("%s-%s", storage.cae_key, storage.sa_key) => storage
  }

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
# Container App Environments
#----------------------------------------------------------
module "container_app_environments" {
  source   = "./modules/containers/container_app/environment"
  for_each = local.containers.container_app_environments

  name                           = each.value.name
  resource_group_name            = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location                       = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                           = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)
  log_analytics_workspace_id     = can(each.value.log_analytics_workspace_id) ? each.value.log_analytics_workspace_id : try(module.log_analytics[each.value.log_analytics_workspace_key].id, null)
  infrastructure_subnet_id       = can(each.value.infrastructure_subnet_id) ? each.value.infrastructure_subnet_id : try(module.virtual_subnets[each.value.infrastructure_vnet_key].subnets[each.value.infrastructure_subnet_key].id, null)
  internal_load_balancer_enabled = try(each.value.internal_load_balancer_enabled, null)
}

#----------------------------------------------------------
# Container App Environment Certificates
#----------------------------------------------------------
module "container_app_environment_certificates" {
  source   = "./modules/containers/container_app/environment_certificate"
  for_each = try(local.container_app_environment_certificates, {})

  depends_on = [module.container_app_environments]

  name                         = each.value.name
  container_app_environment_id = each.value.container_app_environment_id
  certificate_blob_base64      = each.value.certificate_blob_base64
  certificate_password         = each.value.certificate_password
  tags                         = try(each.value.tags, {})
}

#----------------------------------------------------------
# Container App Environment Dapr Components
#----------------------------------------------------------
module "container_app_environment_dapr_components" {
  source   = "./modules/containers/container_app/environment_dapr_component"
  for_each = try(local.container_app_environment_dapr_components)

  depends_on = [module.container_app_environments]

  name                         = each.value.name
  container_app_environment_id = each.value.container_app_environment_id
  type                         = each.value.type
  component_version            = each.value.version
  ignore_errors                = try(each.value.ignore_errors, null)
  init_timeout                 = try(each.value.init_timeout, null)
  metadata                     = try(each.value.metadata, null)
  scopes                       = try(each.value.scopes, null)
  secret                       = try(each.value.secret, null)
}

#----------------------------------------------------------
# Container App Environment Storage
#----------------------------------------------------------
module "container_app_environment_storage" {
  source   = "./modules/containers/container_app/environment_storage"
  for_each = try(local.container_app_environment_storage, {})

  depends_on = [module.container_app_environments]

  name                         = each.value.name
  container_app_environment_id = each.value.container_app_environment_id
  account_name                 = each.value.account_name
  access_key                   = each.value.access_key
  access_mode                  = each.value.access_mode
  share_name                   = each.value.share_name
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
  revision_mode                = each.value.revision_mode
  template                     = each.value.template
  dapr                         = try(each.value.dapr, {})
  identity                     = try(local.container_app_managed_identities, {})
  ingress                      = try(each.value.ingress, {})
  registry                     = try(each.value.registry, {})
  secret                       = try(each.value.secret, {})
}