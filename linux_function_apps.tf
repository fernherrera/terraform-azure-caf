#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Default linux function app settings
  default_linux_function_apps_settings = {
    site_config = {
      always_on = false
      application_stack = {
        dotnet_version = "v6.0"
      }
      use_32_bit_worker = false
    }
  }
}

#----------------------------------------------------------
# Linux App Functions
#----------------------------------------------------------
module "linux_function_apps" {
  source = "./modules/app_service/linux_function_app"
  #   depends_on = [module.networking]
  for_each = local.web.linux_function_apps

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  service_plan_id                     = can(each.value.app_service_plan_id) ? each.value.app_service_plan_id : module.app_service_plans[each.value.app_service_plan_key].id
  app_settings                        = try(each.value.app_settings, null)
  builtin_logging_enabled             = try(each.value.builtin_logging_enabled, null)
  client_certificate_enabled          = try(each.value.client_certificate_enabled, null)
  client_certificate_mode             = try(each.value.client_certificate_mode, null)
  client_certificate_exclusion_paths  = try(each.value.client_certificate_exclusion_paths, null)
  connection_strings                  = try(each.value.connection_strings, {})
  content_share_force_disabled        = try(each.value.content_share_force_disabled, null)
  diagnostic_settings                 = try(each.value.diagnostic_settings, {})
  daily_memory_time_quota             = try(each.value.daily_memory_time_quota, 0)
  enabled                             = try(each.value.enabled, null)
  functions_extension_version         = try(each.value.functions_extension_version, null)
  https_only                          = try(each.value.https_only, null)
  identity                            = try(each.value.identity, null)
  key_vault_reference_identity_id     = try(each.value.key_vault_reference_identity_id, null)
  settings                            = merge(try(local.default_linux_function_apps_settings, {}), try(each.value.settings, {}))
  storage_account_access_key          = can(each.value.storage_account_access_key) ? each.value.storage_account_access_key : module.storage_accounts[each.value.storage_account_key].primary_access_key
  storage_account_name                = can(each.value.storage_account_name) ? each.value.storage_account_name : module.storage_accounts[each.value.storage_account_key].name
  storage_uses_managed_identity       = try(each.value.storage_uses_managed_identity, null)
  storage_key_vault_secret_id         = try(each.value.storage_key_vault_secret_id, null)
  virtual_network_integration_enabled = try(each.value.vnet_integration_enabled, false)
  virtual_network_subnet_id           = can(each.value.vnet_integration_enabled) && can(each.value.virtual_network_subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : module.virtual_subnets[each.value.vnet_key].subnets[each.value.subnet_key].id
  application_insight                 = try(each.value.application_insight_key, null) == null ? null : module.application_insights[each.value.application_insight_key]
}

output "linux_function_apps" {
  value     = module.linux_function_apps
  sensitive = true
}
