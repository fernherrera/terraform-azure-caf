#----------------------------------------------------------
# Local declarations
#----------------------------------------------------------
locals {
  keyvault_private_endpoints = {
    for private_endpoint in
    flatten(
      [
        for kv_key, kv in local.security.keyvaults : [
          for pe_key, pe in try(kv.private_endpoints, {}) : {
            kv_key              = kv_key
            pe_key              = pe_key
            id                  = module.keyvaults[kv_key].id
            resource_group_name = module.resource_groups[pe.resource_group_key].name
            location            = module.resource_groups[pe.resource_group_key].location
            tags                = module.keyvaults[kv_key].tags
            name                = try(pe.name, "")
            subnet_id           = try(pe.vnet_key, null) == null ? null : try(module.virtual_subnets[pe.vnet_key].subnets[pe.subnet_key].id)
            private_service_connection = merge(try(pe.private_service_connection, {}), {
              private_connection_resource_id = module.keyvaults[kv_key].id
              subresource_names              = ["vault"]
            })
          }
        ]
      ]
    ) : format("%s-%s", private_endpoint.kv_key, private_endpoint.pe_key) => private_endpoint
  }

  keyvault_diagnostics_defaults = {
    name        = "operational_logs_and_metrics"
    enabled_log = []
    log = [
      {
        name    = "AuditEvent"
        enabled = true
        retention_policy = {
          enabled = true
          days    = 7
        }
      },
      {
        name    = "AzurePolicyEvaluationDetails"
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
# Key Vaults
#----------------------------------------------------------
module "keyvaults" {
  source   = "./modules/security/keyvault"
  for_each = local.security.keyvaults

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  client_config                   = local.client_config
  tenant_id                       = local.client_config.tenant_id
  sku_name                        = try(each.value.sku_name, "standard")
  enabled_for_deployment          = try(each.value.enabled_for_deployment, null)
  enabled_for_disk_encryption     = try(each.value.enabled_for_disk_encryption, null)
  enabled_for_template_deployment = try(each.value.enabled_for_template_deployment, null)
  enable_rbac_authorization       = try(each.value.enable_rbac_authorization, null)
  purge_protection_enabled        = try(each.value.purge_protection_enabled, null)
  public_network_access_enabled   = try(each.value.public_network_access_enabled, null)
  soft_delete_retention_days      = try(each.value.soft_delete_retention_days, null)
  contact                         = try(each.value.contact, {})
  network_acls                    = try(each.value.network_acls, {})

  settings           = each.value.settings
  vnets              = try(each.value.vnets, {})
  resource_groups    = try(each.value.resource_groups, {})
  private_dns        = try(each.value.private_dns, {})
  azuread_groups     = try(each.value.azuread_groups, {})
  managed_identities = try(each.value.managed_identities, {})
}

# Keyvault access policies
module "keyvault_access_policies" {
  source   = "./modules/security/keyvault_access_policies"
  for_each = local.security.keyvault_access_policies

  keyvault_key    = each.value.keyvault_key
  keyvaults       = module.keyvaults
  access_policies = each.value.access_policies
  client_config   = local.client_config
  azuread_groups  = {}
  resources = {
    azuread_service_principals        = {}
    diagnostic_storage_accounts       = {}
    managed_identities                = module.managed_identities
    mssql_managed_instances           = {}
    mssql_managed_instances_secondary = {}
    storage_accounts                  = module.storage_accounts
  }
}

# Need to separate keyvault policies from azure AD apps to get the keyvault with the default policies.
# Reason - Azure AD apps passwords are stored into keyvault secrets and combining would create a circular reference
module "keyvault_access_policies_azuread_apps" {
  source   = "./modules/security/keyvault_access_policies"
  for_each = local.security.keyvault_access_policies_azuread_apps

  keyvault_key    = each.key
  keyvaults       = module.keyvaults
  access_policies = each.value
  client_config   = local.client_config
  azuread_apps    = {}
}

#--------------------------------------
# Key Vault Private Endpoints
#--------------------------------------
module "keyvault_private_endpoints" {
  source   = "./modules/networking/private_endpoint"
  for_each = local.keyvault_private_endpoints

  depends_on = [module.keyvaults]

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

#----------------------------------------------------------
# Key Vault Diagnostic Setting
#----------------------------------------------------------
module "keyvault_diagnostics" {
  source   = "./modules/monitor/diagnostic_settings"
  for_each = local.security.keyvaults

  target_resource_id = module.keyvaults[each.key].id

  eventhub_name                  = try(each.value.diagnostic_settings.eventhub_name, null)
  eventhub_authorization_rule_id = try(each.value.diagnostic_settings.eventhub_authorization_rule_id, null)

  log_analytics_workspace_id     = try(each.value.diagnostic_settings.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(each.value.diagnostic_settings.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.diagnostic_settings.partner_solution_id, null)
  storage_account_id  = try(each.value.diagnostic_settings.storage_account_id, null)

  name        = try(each.value.diagnostic_settings.name, local.keyvault_diagnostics_defaults.name)
  enabled_log = try(each.value.diagnostic_settings.enabled_log, local.keyvault_diagnostics_defaults.enabled_log, [])
  log         = try(each.value.diagnostic_settings.log, local.keyvault_diagnostics_defaults.log, [])
  metric      = try(each.value.diagnostic_settings.metric, local.keyvault_diagnostics_defaults.metric, [])
}