#----------------------------------------------------------
# IP Groups
#----------------------------------------------------------
module "ip_groups" {
  source   = "./modules/networking/ip_group"
  for_each = local.networking.ip_groups

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, module.resource_groups[each.value.resource_group_key].location, null)
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )
  cidrs               = try(each.value.cidrs, [])
}

output "ip_groups" {
  value = module.ip_groups
}