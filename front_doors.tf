#----------------------------------------------------------
# Locals declarations for Azure CDN Front Door
#----------------------------------------------------------
locals {
  cdn_frontdoor_endpoints = { for endpoint in local.cdn_frontdoor_endpoints_flattened : endpoint.composite_key => endpoint }

  cdn_frontdoor_endpoints_flattened = flatten([
    for fk, fd in module.cdn_frontdoors : [
      for ek, ep in fd.endpoints : merge(
        ep,
        {
          composite_key = format("%s_%s", fk, ek)
          frontdoor_key = fk
          endpoint_key  = ek
        },
      )
    ]
  ])
}

#----------------------------------------------------------
# Front Doors (Classic)
#----------------------------------------------------------
module "frontdoors" {
  source   = "./modules/networking/frontdoor"
  for_each = local.networking.frontdoors

  frontdoor_name      = each.value.frontdoor_name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  friendly_name                   = try(each.value.friendly_name, "")
  backend_pools                   = try(each.value.backend_pools, [])
  backend_pool_health_probes      = try(each.value.backend_pool_health_probes, [])
  backend_pool_load_balancing     = try(each.value.backend_pool_load_balancing, [])
  frontend_endpoints              = try(each.value.frontend_endpoints, [])
  routing_rules                   = try(each.value.routing_rules, [])
  web_application_firewall_policy = try(each.value.web_application_firewall_policy, null)
  log_analytics_workspace_name    = try(each.value.log_analytics_workspace_name, null)
  storage_account_name            = try(each.value.storage_account_name, null)
  fd_diag_logs                    = try(each.value.fd_diag_logs, null)
}

output "frontdoors" {
  value = module.frontdoors
}


#----------------------------------------------------------
# Front Doors (Standard/Premium)
#----------------------------------------------------------
module "cdn_frontdoors" {
  source   = "./modules/networking/cdn_frontdoor"
  for_each = local.networking.cdn_frontdoors

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  tags                = merge(lookup(each.value, "tags", {}), try(var.tags, {}), )

  sku_name                 = each.value.sku_name
  response_timeout_seconds = try(each.value.response_timeout_seconds, 120)
  endpoints                = try(each.value.endpoints, {})
  origin_groups            = try(each.value.origin_groups, {})
  origins                  = try(each.value.origins, {})
  routes                   = try(each.value.routes, {})
  custom_domains           = try(each.value.custom_domains, {})
  secrets                  = try(each.value.secrets, {})
  waf_policies             = try(each.value.waf_policies, {})
  security_policies        = try(each.value.security_policies, {})
  key_vaults               = local.combined_objects.keyvaults
}