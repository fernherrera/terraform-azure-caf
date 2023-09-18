module "resource_groups" {
  source   = "./modules/resource_group"
  for_each = local.resource_groups

  name     = each.value.name
  location = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  existing = try(each.value.existing, false)
  tags     = merge(try(each.value.tags, {}), local.global_settings.tags)
}
