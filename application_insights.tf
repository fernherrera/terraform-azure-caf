module "application_insights" {
  source   = "./modules/application_insights"
  for_each = local.web.app_insights

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  application_type                      = try(each.value.application_type, "other")
  diagnostics                           = try(each.value.diagnostics, null)
  diagnostic_profiles                   = try(each.value.diagnostic_profiles, null)
  daily_data_cap_in_gb                  = try(each.value.daily_data_cap_in_gb, null)
  daily_data_cap_notifications_disabled = try(each.value.daily_data_cap_notifications_disabled, null)
  disable_ip_masking                    = try(each.value.disable_ip_masking, null)
  retention_in_days                     = try(each.value.retention_in_days, 90)
  sampling_percentage                   = try(each.value.sampling_percentage, null)
  workspace_id                          = can(each.value.workspace_id) ? try(each.value.workspace_id, null) : try(local.combined_objects.log_analytics[each.value.workspace_key].id, null)
}
