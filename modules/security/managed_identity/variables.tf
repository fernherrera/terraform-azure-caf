variable "name" {
  description = "(Required) Specifies the name of this User Assigned Identity."
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group within which this User Assigned Identity should exist."
}

variable "location" {
  description = "(Required) The Azure Region where the User Assigned Identity should exist."
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the User Assigned Identity."
}