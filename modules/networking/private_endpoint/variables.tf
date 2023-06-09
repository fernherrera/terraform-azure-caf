variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
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

variable "name" {
  description = "(Required) Specifies the name. Changing this forces a new resource to be created."
  type        = string
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint."
}

variable "private_service_connection" {
  description = "(Required) A private_service_connection block."
}

variable "private_dns_zone_group" {
  description = "(Optional) A private_dns_zone_group block."
  default     = {}
}

variable "custom_network_interface_name" {
  description = "(Optional) The custom name of the network interface attached to the private endpoint."
  default     = null
}

variable "ip_configuration" {
  description = "(Optional) One or more ip_configuration blocks. This allows a static IP address to be set for this Private Endpoint, otherwise an address is dynamically allocated from the Subnet."
  default     = []
}
