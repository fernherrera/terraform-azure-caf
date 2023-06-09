variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "name" {
  description = "(Required) The name of the DNS Zone. Must be a valid domain name."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "soa_record" {
  description = "(Optional) An soa_record block"
  default     = {}
}

variable "records" {
  description = "(Optional) Configuration map - DNS Records."
  default     = {}
}

variable "resource_ids" {
  default = {}
}