#----------------------------------------------------------
# Private DNS Resolvers
#----------------------------------------------------------
module "private_dns_resolver" {
  source   = "./modules/networking/private_dns_resolver"
  for_each = local.networking.private_dns_resolvers

  depends_on = [
    module.virtual_subnets
  ]

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)
  virtual_network_id  = try(each.value.virtual_network_id, module.virtual_networks.vnets[each.value.virtual_network_key].id, null)
  virtual_networks    = try(module.virtual_networks, {})
  virtual_subnets     = try(module.virtual_subnets, {})
  inbound_endpoints   = try(each.value.inbound_endpoints, {})
  outbound_endpoints  = try(each.value.outbound_endpoints, {})
  forwarding_rulesets = try(each.value.forwarding_rulesets, {})
}