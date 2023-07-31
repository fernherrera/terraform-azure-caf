variable "name" {
  description = "(Required) The name of the Microsoft SQL Server. This needs to be globally unique within Azure. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Required) The name of the resource group in which to create the Microsoft SQL Server. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "server_version" {
  description = "(Required) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created."
  type        = string
}

variable "administrator_login" {
  description = "(Optional) The administrator login name for the new server. Required unless azuread_authentication_only in the azuread_administrator block is true. When omitted, Azure will generate a default username which cannot be subsequently changed. Changing this forces a new resource to be created."
  default     = null
}

variable "administrator_login_password" {
  description = "(Optional) The password associated with the administrator_login user. Needs to comply with Azure's Password Policy. Required unless azuread_authentication_only in the azuread_administrator block is true."
  default     = null
}

variable "azuread_administrator" {
  description = "(Optional) An azuread_administrator block."
  default     = {}
}

variable "azuread_groups" {
  description = ""
  default     = {}
}

variable "connection_policy" {
  description = "(Optional) The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default."
  default     = "Default"
}

variable "existing" {
  description = "(Optional) Whether to reference an existing resource group."
  default     = false
  type        = bool
}

variable "firewall_rules" {
  description = "(Optional) One or more firewall_rules blocks."
  default     = {}
}

variable "identity" {
  description = "(Optional) An identity block."
  default     = {}
}

variable "minimum_tls_version" {
  description = "(Optional) The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 , 1.2 and Disabled. Defaults to 1.2."
  default     = "1.2"
}

variable "outbound_network_restriction_enabled" {
  description = "(Optional) Whether outbound network traffic is restricted for this server. Defaults to false."
  default     = false
}

variable "primary_user_assigned_identity_id" {
  description = "(Optional) Specifies the primary user managed identity id. Required if type is UserAssigned and should be combined with identity_ids."
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this server. Defaults to true."
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "transparent_data_encryption_key_vault_key_id" {
  description = "(Optional) The fully versioned Key Vault Key URL (e.g. 'https://<YourVaultName>.vault.azure.net/keys/<YourKeyName>/<YourKeyVersion>) to be used as the Customer Managed Key(CMK/BYOK) for the Transparent Data Encryption(TDE) layer."
  default     = null
}

variable "virtual_networks" {
  default = {}
}

variable "virtual_network_rules" {
  description = "(Optional) One or more virtual_network_rules blocks."
  default     = {}
}



variable "private_endpoints" {
  default = {}
}

variable "private_dns" {
  default = {}
}

variable "keyvault_id" {
  default = null
}

variable "remote_objects" {
  default = {}
}

variable "storage_accounts" {
  default = {}
}

