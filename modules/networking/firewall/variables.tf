variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "(Required) Resource Group of the Azure Firewall to be created"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) Name of the Azure Firewall to be created"
  type        = string
}

variable "sku_name" {
  description = "(Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet."
}

variable "sku_tier" {
  description = "(Required) SKU tier of the Firewall. Possible values are Premium and Standard."
}

variable "firewall_policy_id" {
  description = "(Optional) The ID of the Firewall Policy applied to this Firewall."
  default     = null
}

variable "ip_configuration" {
  description = "(Optional) An ip_configuration block"
  default     = {}
}

variable "dns_servers" {
  description = "(Optional) A list of DNS servers that the Azure Firewall will direct DNS traffic to the for name resolution."
  default     = null
}

variable "private_ip_ranges" {
  description = "Optional) A list of SNAT private CIDR IP ranges, or the special string IANAPrivateRanges, which indicates Azure Firewall does not SNAT when the destination IP address is a private range per IANA RFC 1918."
  default     = null
}

variable "management_ip_configuration" {
  description = "(Optional) A management_ip_configuration block as documented below, which allows force-tunnelling of traffic to be performed by the firewall."
  default     = {}
}

variable "threat_intel_mode" {
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny and (empty string)."
  default     = "Alert"
}

variable "virtual_hub" {
  description = "(Optional) A virtual_hub block"
  default     = null
}

variable "zones" {
  description = "(Optional) Specifies a list of Availability Zones in which this Azure Firewall should be located."
  default     = null
}

variable "public_ip_addresses" {
}

variable "virtual_wans" {
  default = {}
}

variable "virtual_hubs" {
  default = {}
}

variable "virtual_networks" {
  default = {}
}

variable "diagnostics" {
  default = {}
}

variable "diagnostic_profiles" {
  default = {}
}