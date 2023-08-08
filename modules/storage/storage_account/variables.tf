variable "name" {
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "account_tier" {
  description = "(Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  type        = string
  default     = "StorageV2"
}

variable "access_tier" {
  description = "(Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  description = "(Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true."
  type        = bool
  default     = true
}

variable "existing" {
  description = "(Optional) Whether to reference an existing resource group."
  default     = false
  type        = bool
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "custom_domain" {
  default = null
}

variable "enable_system_msi" {
  default = {}
}

variable "identity" {
  default = null
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
