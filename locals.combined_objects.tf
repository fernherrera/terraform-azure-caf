#-----------------------------------------------------------------------------
# Landing zones can retrieve remote objects from a different landing zone 
# and the combined_objects will merge it with the local objects.
#-----------------------------------------------------------------------------
locals {
  combined_objects = {
    private_dns = merge(try(module.private_dns, {}), try(data.azurerm_private_dns_zone.dns, {}))
  }
}