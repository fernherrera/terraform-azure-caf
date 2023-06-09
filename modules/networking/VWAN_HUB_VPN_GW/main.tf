data "azurerm_virtual_hub" "vwan_hub" {
  for_each            = var.vwan_hub_vpn_gw
  name                = each.value["virtual_hub_name"]
  resource_group_name = each.value["resource_group_name"]
}

resource "azurerm_vpn_gateway" "vwan_vpn_gateway" {
  for_each            = var.vwan_hub_vpn_gw
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  virtual_hub_id      = data.azurerm_virtual_hub.vwan_hub[each.key].id
  scale_unit          = each.value["scale_unit"]
  lifecycle {
    ignore_changes = all
  }
}
