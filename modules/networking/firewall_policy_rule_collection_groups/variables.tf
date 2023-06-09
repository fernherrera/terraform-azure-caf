variable "name" {
  description = "(Required) The name which should be used for this Firewall Policy Rule Collection Group."
}

variable "firewall_policy_id" {
  description = "(Required) The ID of the Firewall Policy where the Firewall Policy Rule Collection Group should exist. Changing this forces a new Firewall Policy Rule Collection Group to be created."
}

variable "priority" {
  description = "(Required) The priority of the Firewall Policy Rule Collection Group. The range is 100-65000."
}

variable "application_rule_collections" {
  description = "(Optional) One or more application_rule_collection blocks"
  default     = {}
}

variable "nat_rule_collections" {
  description = "(Optional) One or more nat_rule_collection blocks"
  default     = {}
}

variable "network_rule_collections" {
  description = "Optional) One or more network_rule_collection blocks"
  default     = {}
}

variable "ip_groups" {
  description = "(Optional) Specifies a map of source IP groups."
  default     = {}
}

variable "public_ip_addresses" {
  description = "(Optional) A map of destination IP addresses (including CIDR)."
  default     = {}
}