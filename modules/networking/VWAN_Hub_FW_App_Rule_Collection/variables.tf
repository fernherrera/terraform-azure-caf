variable "apprulecollectiongrp" {
  type = map(object({
    fw_policy_name      = string
    resource_group_name = string
    name                = string
    priority            = number
    action              = string
    rule_name           = string
    protocol_type_http  = string
    http_port           = number
    protocol_type_https = string
    https_port          = number
    source_addresses    = list(string)
    destination_fqdns   = list(string)
  }))
  default = {}
}