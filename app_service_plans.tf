module "app_service_plans" {
  source   = "./modules/app_service/service_plan"
  for_each = local.web.app_service_plans

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  os_type                      = each.value.os_type
  sku_name                     = each.value.sku_name
  app_service_environment_id   = try(each.value.app_service_environment_id, null)
  maximum_elastic_worker_count = try(each.value.maximum_elastic_worker_count, null)
  worker_count                 = try(each.value.worker_count, null)
  per_site_scaling_enabled     = try(each.value.per_site_scaling_enabled, false)
  zone_balancing_enabled       = try(each.value.zone_balancing_enabled, false)
}

output "app_service_plans" {
  value = module.app_service_plans
}