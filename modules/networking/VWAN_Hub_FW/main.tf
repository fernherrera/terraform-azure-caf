data "azurerm_virtual_hub" "vwan_hub" {
  for_each            = var.vwan_hub_fw_variables
  name                = each.value["hub_name"]
  resource_group_name = each.value["resource_group_name"]
  # address_prefixes=each.value["address_prefixes"]
}

data "azurerm_firewall_policy" "fwpolicy" {
  for_each            = var.vwan_hub_fw_variables
  name                = each.value["fw_policy_name"]
  resource_group_name = each.value["resource_group_name"]

}

resource "azurerm_firewall" "firewall" {
  for_each            = var.vwan_hub_fw_variables
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
  location            = each.value["location"]
  sku_name            = each.value["sku_name"]
  sku_tier            = each.value["sku_tier"]
  // threat_intel_mode   = each.value["threat_intel_mode"]
  firewall_policy_id = data.azurerm_firewall_policy.fwpolicy[each.key].id
  tags               = each.value["fw_tags"]

  virtual_hub {
    virtual_hub_id  = data.azurerm_virtual_hub.vwan_hub[each.key].id
    public_ip_count = each.value["public_ip_count"]
  }

  lifecycle {
    ignore_changes = [
      virtual_hub,
      firewall_policy_id
    ]
  }

}
