#--------------------------------------
# Local declarations
#--------------------------------------
locals {
  data_factory_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.data_factory.data_factory : {
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

  data_factory_private_endpoints = {
    for private_endpoint in
    flatten(
      [
        for adf_key, adf in local.data_factory.data_factory : [
          for pe_key, pe in try(adf.private_endpoints, {}) : {
            adf_key             = adf_key
            pe_key              = pe_key
            id                  = module.data_factory[adf_key].id
            resource_group_name = module.resource_groups[pe.resource_group_key].name
            location            = module.resource_groups[pe.resource_group_key].location
            tags                = module.data_factory[adf_key].tags
            name                = try(pe.name, "")
            subnet_id           = try(pe.vnet_key, null) == null ? null : try(module.virtual_subnets[pe.vnet_key].subnets[pe.subnet_key].id)
            private_service_connection = merge(try(pe.private_service_connection, {}), {
              private_connection_resource_id = module.data_factory[adf_key].id
            })
          }
        ]
      ]
    ) : format("%s-%s", private_endpoint.adf_key, private_endpoint.pe_key) => private_endpoint
  }

  data_factory_diagnostics_defaults = {
    name = "operational_logs_and_metrics"
    log = [
      {
        name    = "ActivityRuns"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "PipelineRuns"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "TriggerRuns"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SandboxPipelineRuns"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SandboxActivityRuns"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SSISPackageEventMessages"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SSISPackageExecutableStatistics"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SSISPackageEventMessageContext"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SSISPackageExecutionComponentPhases"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SSISPackageExecutionDataStatistics"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "SSISIntegrationRuntimeLogs"
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

#--------------------------------------
# Azure Data Factory
#--------------------------------------
module "data_factory" {
  source   = "./modules/data_factory/data_factory"
  for_each = local.data_factory.data_factory

  depends_on = [
    module.resource_groups
  ]

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  diagnostics         = try(each.value.diagnostics, null)
  diagnostic_profiles = try(each.value.diagnostic_profiles, {})
  identity            = try(local.data_factory_managed_identities[each.key], null)
  resource_groups     = module.resource_groups
  virtual_subnets     = module.virtual_subnets
  private_endpoints   = try(each.value.private_endpoints, {})
  private_dns         = local.combined_objects.private_dns
  settings            = each.value
}

#--------------------------------------
# Data Factory Private Endpoints
#--------------------------------------
module "data_factory_private_endpoints" {
  source   = "./modules/networking/private_endpoint"
  for_each = local.data_factory_private_endpoints

  depends_on = [module.data_factory]

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tags                          = each.value.tags
  subnet_id                     = each.value.subnet_id
  private_service_connection    = each.value.private_service_connection
  private_dns_zone_group        = try(each.value.private_dns_zone_group, {})
  custom_network_interface_name = try(each.value.custom_network_interface_name, null)
  ip_configuration              = try(each.value.ip_configuration, [])
}

#--------------------------------------
# Data Factory Diagnostic settings
#--------------------------------------
module "data_factory_diagnostics" {
  source   = "./modules/monitor/diagnostic_settings"
  for_each = local.data_factory.data_factory

  target_resource_id = module.data_factory[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, null)

  name        = try(each.value.diagnostic_settings.name, local.data_factory_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.data_factory_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.data_factory_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.data_factory_diagnostics_defaults.metric, [])
}

#--------------------------------------
# Data Factory Pipelines
#--------------------------------------
module "data_factory_pipeline" {
  source   = "./modules/data_factory/data_factory_pipeline"
  for_each = local.data_factory.data_factory_pipeline

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
  settings        = each.value
}

#--------------------------------------
# Data Factory Trigger Schedule
#--------------------------------------
module "data_factory_trigger_schedule" {
  source   = "./modules/data_factory/data_factory_trigger_schedule"
  for_each = local.data_factory.data_factory_trigger_schedule

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
  pipeline_name   = can(each.value.data_factory_pipeline.name) ? each.value.data_factory_pipeline.name : module.data_factory_pipeline[each.value.data_factory_pipeline.key].name
  settings        = each.value
}

#--------------------------------------
# Data Factory Integration Runtime (Self-Hosted)
#--------------------------------------
module "data_factory_integration_runtime_self_hosted" {
  source   = "./modules/data_factory/data_factory_integration_runtime_self_hosted"
  for_each = local.data_factory.data_factory_integration_runtime_self_hosted

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
}

#--------------------------------------
# Data Factory Integration Runtime (SSIS)
#--------------------------------------
module "data_factory_integration_runtime_azure_ssis" {
  source   = "./modules/data_factory/data_factory_integration_runtime_azure_ssis"
  for_each = local.data_factory.data_factory_integration_runtime_azure_ssis

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
  settings        = each.value

  remote_objects = {
    resource_groups          = module.resource_groups
    keyvaults                = module.keyvaults
    dynamic_keyvault_secrets = local.security.dynamic_keyvault_secrets
  }
}
