module "linux_web_apps" {
  source = "./modules/app_service/linux_web_app"
  #   depends_on = [module.networking]
  for_each = local.web.linux_web_apps

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  application_insight                 = try(each.value.application_insight_key, null) == null ? null : module.application_insights[each.value.application_insight_key]
  app_settings                        = try(each.value.app_settings, null)
  client_affinity_enabled             = try(each.value.client_affinity_enabled, null)
  client_certificate_enabled          = try(each.value.client_certificate_enabled, null)
  client_certificate_mode             = try(each.value.client_certificate_mode, null)
  client_certificate_exclusion_paths  = try(each.value.client_certificate_exclusion_paths, null)
  connection_strings                  = try(each.value.connection_strings, {})
  enabled                             = try(each.value.enabled, null)
  https_only                          = try(each.value.https_only, null)
  identity                            = try(each.value.identity, null)
  key_vault_reference_identity_id     = try(each.value.key_vault_reference_identity_id, null)
  service_plan_id                     = can(each.value.app_service_plan_id) ? each.value.app_service_plan_id : module.app_service_plans[each.value.app_service_plan_key].id
  settings                            = merge(try(local.default_linux_web_apps_settings, {}), try(each.value.settings, {}))
  storage_accounts                    = try(local.combined_objects.storage_accounts, null)
  zip_deploy_file                     = try(each.value.zip_deploy_file, null)
  virtual_network_integration_enabled = try(each.value.vnet_integration_enabled, false)
  virtual_network_subnet_id           = can(each.value.vnet_integration_enabled) && can(each.value.virtual_network_subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : module.virtual_subnets[each.value.vnet_key].subnets[each.value.subnet_key].id
}

output "linux_web_apps" {
  value     = module.linux_web_apps
  sensitive = true
}