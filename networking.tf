#----------------------------------------------------------
# Virtual Networks
#----------------------------------------------------------
module "virtual_networks" {
  source   = "./modules/networking/virtual_network"
  for_each = local.networking.virtual_networks

  depends_on = [
    module.resource_groups
  ]

  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)

  create_resource_group          = try(each.value.create_resource_group, false)
  vnetwork_name                  = try(each.value.vnetwork_name, null)
  vnet_address_space             = try(each.value.vnet_address_space, null)
  create_ddos_plan               = try(each.value.create_ddos_plan, false)
  dns_servers                    = try(each.value.dns_servers, [])
  ddos_plan_name                 = try(each.value.ddos_plan_name, null)
  create_network_watcher         = try(each.value.create_network_watcher, true)
  subnets                        = try(each.value.subnets, {})
  gateway_subnet_address_prefix  = try(each.value.gateway_subnet_address_prefix, null)
  firewall_subnet_address_prefix = try(each.value.firewall_subnet_address_prefix, null)
  firewall_service_endpoints     = try(each.value.firewall_service_endpoints, [])
}

#----------------------------------------------------------
# Virtual Network Subnets
#----------------------------------------------------------
module "virtual_subnets" {
  source   = "./modules/networking/virtual_network/subnet"
  for_each = local.networking.virtual_subnets

  depends_on = [
    module.resource_groups
  ]

  resource_group_name  = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  virtual_network_name = each.value.virtual_network_name
  subnets              = try(each.value.subnets, {})
  tags                 = merge(try(each.value.tags, {}), local.global_settings.tags)
}
