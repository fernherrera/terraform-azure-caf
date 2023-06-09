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

variable "log_analytics_workspace_name" {
  description = "The name of log analytics workspace name"
  default     = null
}

variable "name" {
  description = "The name of the Redis instance"
  default     = ""
}

variable "capacity" {
  description = "Redis size: (Basic/Standard: 1,2,3,4,5,6) (Premium: 1,2,3,4)  https://docs.microsoft.com/fr-fr/azure/redis-cache/cache-how-to-premium-clustering"
  type        = number
  default     = 1
}

variable "sku_name" {
  description = "Redis Cache Sku name. Can be Basic, Standard or Premium"
  type        = string
  default     = "Basic"
}

variable "shard_count" {
  description = "Number of cluster shards desired"
  type        = number
  default     = 2
}

variable "replicas_per_master" {
  description = "Amount of replicas to create per master for this Redis Cache."
  type        = number
  default     = 1
}

variable "minimum_tls_version" {
  description = "The minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "enable_non_ssl_port" {
  description = "Activate non SSL port (6779) for Redis connection"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this Redis Cache."
  type        = bool
  default     = true
}

variable "private_static_ip_address" {
  description = "The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the Subnet within which the Redis Cache should be deployed. Only available when using the Premium SKU"
  default     = null
}

variable "zones" {
  description = "A list of a one or more Availability Zones, where the Redis Cache should be allocated."
  default     = null
  type        = list(number)
}

variable "redis_version" {
  description = "Redis version to deploy. Allowed values are 4 or 6"
  type        = number
  default     = 6
}

variable "redis_configuration" {
  description = "Configuration for the Redis instance"
  type = object({
    enable_authentication           = optional(bool)
    maxmemory_reserved              = optional(number)
    maxmemory_delta                 = optional(number)
    maxmemory_policy                = optional(string)
    maxfragmentationmemory_reserved = optional(number)
    notify_keyspace_events          = optional(string)
  })
  default = {}
}

variable "patch_schedule" {
  description = "The window for redis maintenance. The Patch Window lasts for 5 hours from the `start_hour_utc` "
  type = object({
    day_of_week    = string
    start_hour_utc = number
  })
  default = null
}

variable "storage_account_name" {
  description = "The name of the storage account name"
  default     = null
}

variable "data_persistence_enabled" {
  description = "Enable or disbale Redis Database Backup. Only supported on Premium SKU's"
  default     = false
}

variable "data_persistence_backup_frequency" {
  description = "The Backup Frequency in Minutes. Only supported on Premium SKU's. Possible values are: `15`, `30`, `60`, `360`, `720` and `1440`"
  default     = 60
}

variable "data_persistence_backup_max_snapshot_count" {
  description = "The maximum number of snapshots to create as a backup. Only supported for Premium SKU's"
  default     = 1
}

variable "firewall_rules" {
  description = "Range of IP addresses to allow firewall connections."
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = null
}

variable "enable_private_endpoint" {
  description = "Manages a Private Endpoint to Azure database for Redis"
  default     = false
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  default     = ""
}

variable "existing_private_dns_zone" {
  description = "Name of the existing private DNS zone"
  default     = null
}

variable "private_subnet_address_prefix" {
  description = "The name of the subnet for private endpoints"
  default     = null
}
