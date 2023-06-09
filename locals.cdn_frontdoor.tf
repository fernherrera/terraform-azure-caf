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