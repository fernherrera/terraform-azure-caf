#---------------------------------
# Local declarations
#---------------------------------
locals {
  event_hub_namespaces_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.messaging.event_hub_namespaces : {
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

  event_hub_namespaces_private_endpoints = {
    for private_endpoint in
    flatten(
      [
        for eh_ns_key, eh_ns in local.messaging.event_hub_namespaces : [
          for pe_key, pe in try(eh_ns.private_endpoints, {}) : {
            eh_ns_key           = eh_ns_key
            pe_key              = pe_key
            id                  = module.event_hub_namespaces[eh_ns_key].id
            resource_group_name = module.resource_groups[pe.resource_group_key].name
            location            = module.resource_groups[pe.resource_group_key].location
            tags                = module.event_hub_namespaces[eh_ns_key].tags
            name                = try(pe.name, "")
            subnet_id           = try(pe.vnet_key, null) == null ? null : try(module.virtual_subnets[pe.vnet_key].subnets[pe.subnet_key].id)
            private_service_connection = merge(try(pe.private_service_connection, {}), {
              private_connection_resource_id = module.event_hub_namespaces[eh_ns_key].id
            })
          }
        ]
      ]
    ) : format("%s-%s", private_endpoint.eh_ns_key, private_endpoint.pe_key) => private_endpoint
  }

  event_hub_namespaces_diagnostics_defaults = {
    name = "operational_logs_and_metrics"
    enabled_log = [
      {
        category = "ArchiveLogs"
        enabled  = true
      },
      {
        category = "OperationalLogs"
        enabled  = true
      },
      {
        category = "AutoScaleLogs"
        enabled  = true
      },
      {
        category = "KafkaCoordinatorLogs"
        enabled  = true
      },
      {
        category = "KafkaUserErrorLogs"
        enabled  = true
      },
      {
        category = "EventHubVNetConnectionEvent"
        enabled  = true
      },
      {
        category = "CustomerManagedKeyUserLogs"
        enabled  = true
      },
    ]
    metric = [
      {
        category = "AllMetrics"
        enabled  = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      }
    ]
  }
}

#--------------------------------------
# Event Hub Namespaces
#--------------------------------------
module "event_hub_namespaces" {
  source   = "./modules/messaging/event_hubs/namespaces"
  for_each = local.messaging.event_hub_namespaces

  name                = each.value.name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  existing            = try(each.value.existing, false)
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  sku                           = each.value.sku
  capacity                      = try(each.value.capacity, null)
  auto_inflate_enabled          = try(each.value.auto_inflate_enabled, null)
  dedicated_cluster_id          = try(each.value.dedicated_cluster_id, null)
  identity                      = try(local.event_hub_namespaces_managed_identities[each.key], null)
  maximum_throughput_units      = try(each.value.maximum_throughput_units, null)
  zone_redundant                = try(each.value.zone_redundant, null)
  network_rulesets              = try(each.value.network_rulesets, {})
  local_authentication_enabled  = try(each.value.local_authentication_enabled, null)
  public_network_access_enabled = try(each.value.public_network_access_enabled, null)
  minimum_tls_version           = try(each.value.minimum_tls_version, null)
  auth_rules                    = try(each.value.auth_rules, {})
  event_hubs                    = try(each.value.event_hubs, {})
  storage_accounts              = module.storage_accounts
}


#--------------------------------------
# Event Hub Namespace Authorization Rules
#--------------------------------------
module "event_hub_namespace_auth_rules" {
  source   = "./modules/messaging/event_hubs/namespaces/auth_rules"
  for_each = local.messaging.event_hub_namespace_auth_rules

  depends_on = [module.event_hub_namespaces]

  name                = each.value.name
  namespace_name      = module.event_hub_namespaces[each.value.event_hub_namespace_key].name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  listen              = try(each.value.listen, false)
  send                = try(each.value.send, false)
  manage              = try(each.value.manage, false)
}

#--------------------------------------
# Event Hub Namespaces Private Endpoints
#--------------------------------------
#
# Event_hub_namespace is one of the three diagnostics destination objects and for that reason requires the
# private endpoint to be done at the root module to prevent circular references
#
module "event_hub_namespaces_private_endpoints" {
  source   = "./modules/networking/private_endpoint"
  for_each = local.event_hub_namespaces_private_endpoints

  depends_on = [module.event_hub_namespaces]

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
# Event Hub Namespaces Diagnostic settings
#--------------------------------------
module "event_hub_namespaces_diagnostics" {
  source = "./modules/monitor/diagnostic_settings"
  for_each = {
    for key, val in local.messaging.event_hub_namespaces : key => val
    if try(val.diagnostic_settings, null) != null
  }

  target_resource_id = module.event_hub_namespaces[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, module.event_hubs[each.value.diagnostic_settings.eventhub_key].name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, module.event_hub_namespace_auth_rules[each.value.diagnostic_settings.eventhub_authorization_rule_key].id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, module.log_analytics[each.value.diagnostic_settings.log_analytics_workspace_key].id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, module.storage_accounts[each.value.diagnostic_settings.storage_account_key].id, null)

  name        = try(each.value.diagnostic_settings.name, local.event_hub_namespaces_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.event_hub_namespaces_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.event_hub_namespaces_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.event_hub_namespaces_diagnostics_defaults.metric, [])
}

#--------------------------------------
# Event Hubs
#--------------------------------------
module "event_hubs" {
  source   = "./modules/messaging/event_hubs/hubs"
  for_each = local.messaging.event_hubs

  depends_on = [module.event_hub_namespaces]

  name                = each.value.name
  namespace_name      = module.event_hub_namespaces[each.value.event_hub_namespace_key].name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
  capture_description = try(each.value.capture_description, {})
  status              = try(each.value.status, null)
  auth_rules          = try(each.value.auth_rules, {})
  storage_account_id  = try(module.storage_accounts[each.value.storage_account_key].id, null)
}

#--------------------------------------
# Event Hub Authorization Rules
#--------------------------------------
module "event_hub_auth_rules" {
  source   = "./modules/messaging/event_hubs/hubs/auth_rules"
  for_each = local.messaging.event_hub_auth_rules

  depends_on = [
    module.event_hub_namespaces,
    module.event_hubs
  ]

  name                = each.value.name
  namespace_name      = module.event_hub_namespaces[each.value.event_hub_namespace_key].name
  eventhub_name       = module.event_hubs[each.value.event_hub_key].name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  listen              = try(each.value.listen, false)
  send                = try(each.value.send, false)
  manage              = try(each.value.manage, false)
}

#--------------------------------------
# Event Hub Consumer Groups
#--------------------------------------
module "event_hub_consumer_groups" {
  source   = "./modules/messaging/event_hubs/consumer_groups"
  for_each = local.messaging.event_hub_consumer_groups

  depends_on = [
    module.event_hub_namespaces,
    module.event_hubs
  ]

  name                = each.value.name
  namespace_name      = module.event_hub_namespaces[each.value.event_hub_namespace_key].name
  eventhub_name       = module.event_hubs[each.value.event_hub_name_key].name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  user_metadata       = try(each.value.user_metadata, null)
}