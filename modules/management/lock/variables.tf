variable "name" {
  description = "(Required) Specifies the name of the Management Lock."
}

variable "scope" {
  description = "(Required) Specifies the scope at which the Management Lock should be created."
}

variable "lock_level" {
  description = "(Required) Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly."
}

variable "notes" {
  description = "(Optional) Specifies some notes about the lock. Maximum of 512 characters."
  default     = null
}