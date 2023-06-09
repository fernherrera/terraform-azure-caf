data "azurerm_firewall_policy" "fwpolicy" {
  for_each            = var.apprulecollectiongrp
  name                = each.value["fw_policy_name"]
  resource_group_name = each.value["resource_group_name"]
}

resource "azurerm_firewall_policy_rule_collection_group" "AppRuleCollectionGrp" {
  for_each           = var.apprulecollectiongrp
  name               = "DefaultApplicationRuleCollectionGroup"
  firewall_policy_id = data.azurerm_firewall_policy.fwpolicy.id
  priority           = 300
  application_rule_collection {
    name     = each.value["name"]
    priority = each.value["priority"]
    action   = each.value["action"]
    rule {
      name = each.value["rule_name"]
      protocols {
        type = each.value["protocol_type_http"]
        port = each.value["http_port"]
      }
      protocols {
        type = each.value["protocol_type_https"]
        port = each.value["https_port"]
      }
      source_addresses  = each.value["source_addresses"]
      destination_fqdns = each.value["destination_fqdns"]
    }
  }

}