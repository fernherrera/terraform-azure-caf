variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the Log Analytics Workspace instance"
  type        = string
}

variable "base_policy_id" {
  description = "(Optional) The ID of the base Firewall Policy."
  type        = string
  default     = null
}

variable "dns" {
  description = "(Optional) A dns block"
  default     = {}
}

variable "intrusion_detection" {
  description = "(Optional) A intrusion_detection block"
  default     = {}
}

variable "private_ip_ranges" {
  description = "(Optional) A list of private IP ranges to which traffic will not be SNAT."
  default     = []
}

variable "sku" {
  description = "(Optional) The SKU Tier of the Firewall Policy. Possible values are Standard, Premium."
  default     = null
}

variable "threat_intelligence_allowlist" {
  description = "(Optional) A threat_intelligence_allowlist block"
  default     = {}
}

variable "threat_intelligence_mode" {
  description = "(Optional) The operation mode for Threat Intelligence. Possible values are Alert, Deny and Off. Defaults to Alert."
  default     = "Alert"
}