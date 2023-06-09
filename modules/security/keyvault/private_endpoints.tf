locals {
  private_service_connection = {
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    subresource_names              = ["vault"]
  }
}

module "private_endpoint" {
  source   = "../../networking/private_endpoint"
  for_each = lookup(var.settings, "private_endpoints", {})

  name                       = each.value.name
  location                   = var.resource_groups[try(each.value.resource_group_key)].location
  resource_group_name        = var.resource_groups[try(each.value.resource_group_key)].name
  tags                       = try(merge(var.tags, each.value.tags), {})
  subnet_id                  = can(each.value.subnet_id) ? each.value.subnet_id : var.vnets[each.value.vnet_key].subnets[each.value.subnet_key].id
  private_service_connection = merge(try(each.value.private_service_connection, {}), local.private_service_connection)
}