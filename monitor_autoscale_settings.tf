module "monitor_autoscale_settings" {
  source   = "./modules/monitor/autoscale_setting"
  for_each = local.shared_services.monitor_autoscale_settings

  depends_on = [module.app_service_plans]

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  target_resource_id = can(each.value.target_resource_id) ? each.value.target_resource_id : try(module.app_service_plans[each.value.app_service_plan_key].id, null)
  profiles           = each.value.profiles
  enabled            = try(each.value.enabled, true)
  notification       = try(each.value.notification, {})
}
