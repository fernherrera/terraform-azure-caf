data "azurerm_firewall_policy" "fwpolicy" {
  for_each            = var.nwrulecollectiongrp
  name                = each.value["fw_policy_name"]
  resource_group_name = each.value["resource_group_name"]
}

resource "azurerm_firewall_policy_rule_collection_group" "NWRuleCollectionGrp" {
  for_each           = var.nwrulecollectiongrp
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = data.azurerm_firewall_policy.fwpolicy.id
  priority           = 200
  network_rule_collection {
    name     = each.value["name"]
    priority = each.value["priority"]
    action   = each.value["action"]
    rule {
      name                  = each.value["rule_name"]
      protocols             = each.value["protocols"]
      source_addresses      = each.value["source_addresses"]
      destination_addresses = each.value["destination_addresses"]
      destination_ports     = each.value["destination_ports"]
    }
  }
}