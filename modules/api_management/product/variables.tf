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

variable "product_id" {
  description = "(Required) The Identifier for this Product, which must be unique within the API Management Service."
  type        = string
}

variable "published" {
  description = "(Required) Is this Product Published?"
  type        = string
  default     = true
}

variable "subscription_required" {
  description = "(Required) Is a Subscription required to access API's included in this Product?"
  type        = string
  default     = true
}

# Optional Variables
variable "approval_required" {
  description = "(Optional) Do subscribers need to be approved prior to being able to use the Product?"
  type        = string
  default     = true
}

variable "description" {
  description = "(Optional) A description of this Product, which may include HTML formatting tags."
  default     = null
}

variable "subscriptions_limit" {
  description = "(Optional) The number of subscriptions a user can have to this Product at the same time."
  type        = string
  default     = 1
}