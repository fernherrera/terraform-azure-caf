#----------------------------------------------------------
# DNS Zones
#----------------------------------------------------------
module "dns_zones" {
  source   = "./modules/networking/dns_zone"
  for_each = local.networking.dns_zones

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, module.resource_groups[each.value.resource_group_key].location, null)
  tags                = merge(lookup(each.value, "tags", {}), try(var.tags, {}), )
  soa_record          = try(each.value.soa_record, {})
  records             = try(each.value.records, {})
  resource_ids        = try(each.value.resource_ids, {})
}