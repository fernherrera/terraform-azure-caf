resource "azurerm_firewall_policy" "fwpolicy" {

  for_each            = var.vwan_hub_fw_policy_variables
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
  location            = each.value["location"]
}
