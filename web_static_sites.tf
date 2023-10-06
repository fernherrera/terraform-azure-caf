#---------------------------------
# Local declarations
#---------------------------------
locals {
  static_sites_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.web.static_sites : {
          sa_key = sa_key
          type   = try(sa.identity.type, "SystemAssigned")
          managed_identities = concat(
            try(sa.identity.managed_identity_ids, []),
            flatten([
              for managed_identity_key in try(sa.identity.managed_identity_keys, []) : [
                module.managed_identities[managed_identity_key].id
              ]
            ])
          )
        } if try(sa.identity, null) != null
      ]
    ) : format("%s", managed_identity.sa_key) => managed_identity
  }
}

#----------------------------------------------------------
# Static Sites
#----------------------------------------------------------
module "static_sites" {
  source   = "./modules/web/static_site"
  for_each = local.web.static_sites

  name                = each.value.name
  resource_group_name = try(each.value.resource_group_name, module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)
  sku_tier            = try(each.value.sku_tier, "Free")
  sku_size            = try(each.value.sku_size, "Free")
  identity            = try(local.static_sites_managed_identities[each.key], null)
  custom_domains      = try(each.value.custom_domains, {})
}
