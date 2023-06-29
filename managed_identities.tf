#--------------------------------------
# Managed Identity
#--------------------------------------
module "managed_identities" {
  source   = "./modules/security/managed_identity"
  for_each = local.security.managed_identities

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, module.resource_groups[each.value.resource_group_key].location, null)
  tags                = merge(lookup(each.value, "tags", {}), local.global_settings.tags)
}

output "managed_identities" {
  value = module.managed_identities
}