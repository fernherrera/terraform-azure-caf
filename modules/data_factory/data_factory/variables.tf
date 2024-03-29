variable "name" {
  description = "Name of the API Management service instance"
  type        = string
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
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "settings" {}

variable "diagnostic_profiles" {
  default = {}
}

variable "diagnostics" {
  default = null
}

variable "identity" {
  description = "(Optional) An identity block."
  default     = null
}

variable "resource_groups" {
  default = {}
}

variable "virtual_subnets" {
  default = {}
}

variable "private_endpoints" {
  default = {}
}

variable "private_dns" {
  default = {}
}