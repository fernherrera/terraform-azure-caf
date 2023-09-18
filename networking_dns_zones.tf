#----------------------------------------------------------
# DNS Zones
#----------------------------------------------------------
module "dns_zones" {
  source   = "./modules/networking/dns_zone"
  for_each = local.networking.dns_zones

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)
  soa_record          = try(each.value.soa_record, {})
  records             = try(each.value.records, {})
  resource_ids        = try(each.value.resource_ids, {})
}