data "azurerm_firewall_policy" "fwpolicy" {
  for_each            = var.apprulecollectiongrp
  name                = each.value["fw_policy_name"]
  resource_group_name = each.value["resource_group_name"]
}

resource "azurerm_firewall_policy_rule_collection_group" "DnatRuleCollectionGrp" {
  for_each           = var.apprulecollectiongrp
  name               = "DefaultDnatRuleCollectionGroup"
  firewall_policy_id = data.azurerm_firewall_policy.fwpolicy.id
  priority           = 100
  nat_rule_collection {
    name     = each.value["name"]
    priority = each.value["priority"]
    action   = each.value["action"]
    rule {
      name                = each.value["rule_name"]
      protocols           = each.value["protocols"]
      source_addresses    = each.value["source_addresses"]
      destination_address = each.value["destination_address"]
      destination_ports   = each.value["destination_ports"]
      translated_address  = each.value["translated_address"]
      translated_port     = each.value["translated_port"]
    }
  }
}