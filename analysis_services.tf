#----------------------------------------------------------
# Analysis Services
#----------------------------------------------------------
module "analysis_services" {
  source   = "./modules/analysis_services"
  for_each = local.analysis_services

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  sku                       = each.value.sku
  admin_users               = try(each.value.admin_users, [])
  backup_blob_container_uri = try(each.value.backup_blob_container_uri, null)
  enable_power_bi_service   = try(each.value.enable_power_bi_service, false)
  querypool_connection_mode = try(each.value.querypool_connection_mode, "ReadOnly")
  ipv4_firewall_rule        = try(each.value.ipv4_firewall_rule, {})
}

output "analysis_services" {
  value = module.analysis_services
}