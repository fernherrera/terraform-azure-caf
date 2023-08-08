variable "name" {
  description = "(Required) Specifies the name. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "soa_record" {
  description = "(Optional) An soa_record block. Changing this forces a new resource to be created."
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "records" {
  description = "Configuration object - DNS records."
}

variable "vnet_links" {
  description = "Configuration object - Private DNS Zone Virtual Network Links."
  default     = {}
}
