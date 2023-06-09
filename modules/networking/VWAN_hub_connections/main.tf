// data "azurerm_virtual_network" "vnet" {
//     for_each                = var.vwan_hub_connections
//     #provider                = "azurerm.imx-dev-sub"
//     name                    = each.value["VNet_name"]
//     resource_group_name     = each.value["resource_group_name"]

// }

data "azurerm_virtual_hub" "vwan_hub" {
  for_each            = var.vwan_hub_connections
  name                = each.value["virtual_hub_name"]
  resource_group_name = each.value["resource_group_name"]

}

resource "azurerm_virtual_hub_connection" "vwanhubconnection" {
  for_each       = var.vwan_hub_connections
  name           = each.value["name"]
  virtual_hub_id = data.azurerm_virtual_hub.vwan_hub[each.key].id
  #remote_virtual_network_id = data.azurerm_virtual_network.vnet[each.key].id
  remote_virtual_network_id = each.value["vnet_id"]
  lifecycle {
    ignore_changes = all

  }
}
