#---------------------------------
# Local declarations
#---------------------------------
locals {
  application_gateway_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.networking.application_gateways : {
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
# Application Gateways
#----------------------------------------------------------
# module "application_gateways" {
#   source   = "./modules/networking/application_gateway"
#   for_each = local.networking.application_gateways

#   name                = each.value.name
#   resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
#   location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
#   tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)
#   sku                 = each.value.sku

#   backend_address_pools = each.value.backend_address_pools
#   backend_http_settings = each.value.backend_http_settings

#   frontend_ip_configurations = each.value.frontend_ip_configurations
#   frontend_ports             = each.value.frontend_ports

#   gateway_ip_configuration = each.value.gateway_ip_configuration
#   http_listeners           = each.value.http_listeners

#   request_routing_rules = each.value.request_routing_rules
# }