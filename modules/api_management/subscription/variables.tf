# Required Variables
variable "api_management_name" {
  description = "(Required) The name of the API Management Service."
  type        = string
}

variable "display_name" {
  description = "(Required) The Display Name for this API Management Product."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the API Management Service should be exist."
  type        = string
}

# Optional Variables
variable "product_id" {
  description = "(Optional) The ID of the Product which should be assigned to this Subscription."
  type        = string
  default     = null
}

variable "user_id" {
  description = "(Optional) The ID of the User which should be assigned to this Subscription."
  default     = null
}

variable "api_id" {
  description = "(Optional) The ID of the API which should be assigned to this Subscription."
  default     = null
}

variable "primary_key" {
  description = "(Optional) The primary subscription key to use for the subscription."
  default     = null
}

variable "secondary_key" {
  description = "(Optional) The secondary subscription key to use for the subscription."
  default     = null
}

variable "state" {
  description = "(Optional) The state of this Subscription. Possible values are active, cancelled, expired, rejected, submitted and suspended. Defaults to submitted."
  type        = string
  default     = "submitted"
}

variable "subscription_id" {
  description = "(Optional) An Identifier which should used as the ID of this Subscription. If not specified a new Subscription ID will be generated."
  default     = null
}

variable "allow_tracing" {
  description = "(Optional) Determines whether tracing can be enabled. Defaults to true."
  type        = bool
  default     = true
}