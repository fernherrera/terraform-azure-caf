variable "name" {
  description = "(Required) The name which should be used for this Static Web App. Changing this forces a new Static Web App to be created."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the Static Web App should exist. Changing this forces a new Static Web App to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the Static Web App should exist. Changing this forces a new Static Web App to be created."
  type        = string
}

variable "sku_tier" {
  description = "(Optional) Specifies the SKU tier of the Static Web App. Possible values are Free or Standard. Defaults to Free."
  type        = string
  default     = "Free"
}

variable "sku_size" {
  description = "(Optional) Specifies the SKU size of the Static Web App. Possible values are Free or Standard. Defaults to Free."
  type        = string
  default     = "Free"
}

variable "identity" {
  description = "(Optional) An identity block."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "custom_domains" {
  description = "(Optional) One or more custom domain blocks."
  default     = {}
}