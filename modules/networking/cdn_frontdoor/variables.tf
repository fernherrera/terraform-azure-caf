variable "name" {
  description = "(Required) Specifies the name of the Front Door Profile."
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where this Front Door Profile should exist."
}

variable "sku_name" {
  description = "(Required) Specifies the SKU for this Front Door Profile. Possible values include Standard_AzureFrontDoor and Premium_AzureFrontDoor."
}

variable "response_timeout_seconds" {
  description = "(Optional) Specifies the maximum response timeout in seconds. Possible values are between 16 and 240 seconds (inclusive). Defaults to 120 seconds."
  default     = 120
}

variable "tags" {
  description = "(Optional) Specifies a mapping of tags to assign to the resource."
  default     = {}
}

variable "endpoints" {
  description = "A list of Front Door (standard/premium) endpoints objects."
  default     = {}
}

variable "origin_groups" {
  description = "A map of Front Door (standard/premium) origin group objects."
  default     = {}
}

variable "origins" {
  description = "A map of Front Door (standard/premium) origin objects."
  default     = {}
}

variable "routes" {
  description = "A map of Front Door (standard/premium) route objects."
  default     = {}
}

variable "custom_domains" {
  description = "A map of Front Door (standard/premium) custom domain objects."
  default     = {}
}

variable "secrets" {
  description = "A map of Front Door Secret objects."
  default     = {}
}

variable "waf_policies" {
  description = "A map of one or more web application firewall policy objects."
  default     = {}
}

variable "security_policies" {
  description = "A map of one or more security policy objects."
  default     = {}
}

variable "key_vaults" {
  description = "value"
  default     = {}
}