variable "nwrulecollectiongrp" {
  type = map(object({
    fw_policy_name        = string
    resource_group_name   = string
    name                  = string
    priority              = number
    action                = string
    rule_name             = string
    protocols             = list(string)
    source_addresses      = list(string)
    destination_addresses = string
    destination_ports     = list(string)
  }))
  default = {}
}