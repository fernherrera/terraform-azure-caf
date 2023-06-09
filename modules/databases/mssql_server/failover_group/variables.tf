variable "name" {
  description = "Name of the resource."
  type        = string
}


variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}

variable "settings" {}
variable "primary_server_name" {}
variable "secondary_server_id" {}
variable "databases" {}