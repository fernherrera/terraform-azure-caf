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
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed."
  type        = string
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
  default     = "Hot"
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  type        = string
  default     = "StorageV2"
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  type        = string
  default     = "LRS"
}

variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "enable_https_traffic_only" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  type        = bool
  default     = true
}

variable "infrastructure_encryption_enabled" {
  description = "(Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false."
  type        = bool
  default     = null
}

variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled?"
  type        = bool
  default     = false
}

variable "large_file_share_enabled" {
  description = "(Optional) Is Large File Share Enabled?"
  default     = null
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2."
  type        = string
  default     = "TLS1_2"
}

variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false."
  type        = bool
  default     = false
}

variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are Service and Account."
  type        = string
  default     = null
}

variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the table service. Possible values are Service and Account."
  type        = string
  default     = null
}

variable "custom_domain" {
  default = null
}

variable "enable_system_msi" {
  default = {}
}

variable "identity" {
  default = {}
}

variable "blob_properties" {
  default = {}
}

variable "queue_properties" {
  default = {}
}

variable "static_website" {
  default = {}
}

variable "network" {
  default = {}
}

variable "azure_files_authentication" {
  default = {}
}

variable "routing" {
  default = {}
}

variable "queues" {
  default = {}
}

variable "tables" {
  default = {}
}

variable "containers" {
  default = {}
}

variable "data_lake_filesystems" {
  default = {}
}

variable "file_shares" {
  default = {}
}

variable "management_policies" {
  default = {}
}

variable "backup" {
  default = null
}

variable "private_endpoints" {
  default = {}
}

variable "resource_groups" {
  default = {}
}

variable "recovery_vaults" {
  default = {}
}

variable "private_dns" {
  default = {}
}

variable "diagnostic_profiles" {
  default = {}
}

variable "diagnostics" {
  default = {}
}

variable "managed_identities" {
  default = {}
}

variable "virtual_subnets" {
  default = {}
}