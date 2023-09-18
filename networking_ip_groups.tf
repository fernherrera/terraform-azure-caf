#----------------------------------------------------------
# IP Groups
#----------------------------------------------------------
module "ip_groups" {
  source   = "./modules/networking/ip_group"
  for_each = local.networking.ip_groups

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)
  cidrs               = try(each.value.cidrs, [])
}
