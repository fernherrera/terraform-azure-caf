module "resource_groups" {
  source   = "./modules/resources/resource_group"
  for_each = local.resource_groups

  create_resource_group = try(each.value.create_resource_group, false)
  resource_group_name   = each.value.resource_group_name
  location              = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                  = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )
}

output "resource_groups" {
  value = module.resource_groups
}