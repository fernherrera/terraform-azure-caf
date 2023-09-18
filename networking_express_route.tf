#----------------------------------------------------------
# Express Route Circuits
#----------------------------------------------------------
module "express_route_circuits" {
  source   = "./modules/networking/express_route_circuit"
  for_each = local.networking.express_route_circuits

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  sku                      = each.value.sku
  service_provider_name    = try(each.value.service_provider_name, null)
  peering_location         = try(each.value.peering_location, null)
  bandwidth_in_mbps        = try(each.value.bandwidth_in_mbps, null)
  allow_classic_operations = try(each.value.allow_classic_operations, false)
  express_route_port_id    = try(each.value.express_route_port_id, null)
  bandwidth_in_gbps        = try(each.value.bandwidth_in_gbps, null)
}