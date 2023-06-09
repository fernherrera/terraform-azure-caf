variable "name" {
  description = "(Required) Specifies the name of the EventHub Namespace resource."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the namespace."
}

variable "location" {
  description = "location of the resource if different from the resource group."
  default     = null
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "sku" {
  description = "(Required) Defines which tier to use. Valid options are Basic, Standard, and Premium. Please note that setting this field to Premium will force the creation of a new resource."
}

variable "capacity" {
  description = "(Optional) Specifies the Capacity / Throughput Units for a Standard SKU namespace. Default capacity has a maximum of 2, but can be increased in blocks of 2 on a committed purchase basis. Defaults to 1."
  default     = null
}

variable "auto_inflate_enabled" {
  description = "(Optional) Is Auto Inflate enabled for the EventHub Namespace?"
  type        = bool
  default     = false
}

variable "dedicated_cluster_id" {
  description = "(Optional) Specifies the ID of the EventHub Dedicated Cluster where this Namespace should created. Changing this forces a new resource to be created."
  default     = null
}

variable "identity" {
  description = "(Optional) An identity block"
  default     = {}
}

variable "maximum_throughput_units" {
  description = "(Optional) Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20."
  default     = null
}

variable "zone_redundant" {
  description = "(Optional) Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). Changing this forces a new resource to be created. Defaults to false."
  type        = bool
  default     = false
}

variable "network_rulesets" {
  description = "(Optional) A network_rulesets block."
  default     = {}
}

variable "local_authentication_enabled" {
  description = "(Optional) Is SAS authentication enabled for the EventHub Namespace? Defaults to true."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Is public network access enabled for the EventHub Namespace? Defaults to true."
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "(Optional) The minimum supported TLS version for this EventHub Namespace. Valid values are: 1.0, 1.1 and 1.2. The current default minimum TLS version is 1.2."
  default     = null
}

variable "auth_rules" {
  default = {}
}

variable "event_hubs" {
  default = {}
}

variable "storage_accounts" {
  default = {}
}