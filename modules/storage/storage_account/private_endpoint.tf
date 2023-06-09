#---------------------------------
# Local declarations
#---------------------------------
locals {
  private_service_connection = {
    private_connection_resource_id = azurerm_storage_account.stg.id
  }
}

#--------------------------------------
# Private endpoint
#--------------------------------------
module "private_endpoint" {
  source   = "../../networking/private_endpoint"
  for_each = var.private_endpoints

  name                       = each.value.name
  location                   = var.resource_groups[each.value.resource_group_key].resource_group_location
  resource_group_name        = var.resource_groups[each.value.resource_group_key].resource_group_name
  tags                       = try(merge(var.tags, each.value.tags), {})
  subnet_id                  = can(each.value.subnet_id) ? each.value.subnet_id : try(var.virtual_subnets[each.value.virtual_network_key].subnets[each.value.subnet_key].id, null)
  private_service_connection = merge(try(each.value.private_service_connection, {}), local.private_service_connection)

  private_dns_zone_group = {
    name = try(each.value.private_dns_zone_group.name, "default")
    private_dns_zone_ids = concat(
      flatten([
        for key in try(each.value.private_dns_zone_group.keys, []) : [
          try(var.private_dns[key].id, [])
        ]
        ]
      ),
      try(each.value.private_dns_zone_group.private_dns_zone_ids, [])
    )
  }
}
