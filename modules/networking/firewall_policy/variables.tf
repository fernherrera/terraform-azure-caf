variable "name" {
  description = "(Required) The name which should be used for this Firewall Policy. Changing this forces a new Firewall Policy to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Firewall Policy should exist. Changing this forces a new Firewall Policy to be created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Firewall Policy should exist. Changing this forces a new Firewall Policy to be created."
  type        = string
}

variable "base_policy_id" {
  description = "(Optional) The ID of the base Firewall Policy."
  type        = string
  default     = null
}

variable "dns" {
  description = "(Optional) A dns block."
  default     = {}
}

variable "identity" {
  description = "(Optional) An identity block."
  default     = null
}

variable "insights" {
  description = "(Optional) An insights block."
  default     = {}
}

variable "intrusion_detection" {
  description = "(Optional) A intrusion_detection block."
  default     = {}
}

variable "private_ip_ranges" {
  description = "(Optional) A list of private IP ranges to which traffic will not be SNAT."
  default     = []
}

variable "auto_learn_private_ranges_enabled" {
  description = "(Optional) Whether enable auto learn private ip range."
  default     = null
}

variable "sku" {
  description = "(Optional) The SKU Tier of the Firewall Policy. Possible values are Standard, Premium and Basic. Changing this forces a new Firewall Policy to be created."
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the Firewall Policy."
  type        = map(string)
  default     = {}
}

variable "threat_intelligence_allowlist" {
  description = "(Optional) A threat_intelligence_allowlist block."
  default     = {}
}

variable "threat_intelligence_mode" {
  description = "(Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert."
  default     = "Alert"
}

variable "tls_certificate" {
  description = "(Optional) A tls_certificate block."
  default     = {}
}

variable "sql_redirect_allowed" {
  description = "(Optional) Whether SQL Redirect traffic filtering is allowed. Enabling this flag requires no rule using ports between 11000-11999."
  default     = null
}

variable "explicit_proxy" {
  description = "(Optional) A explicit_proxy block."
  default     = {}
}