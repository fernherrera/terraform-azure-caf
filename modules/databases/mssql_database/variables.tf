variable "name" {
  description = "Name of the resource."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cloud" {}
variable "location" {}
variable "settings" {}
variable "server_id" {}
variable "server_name" {}
variable "storage_accounts" {}

variable "elastic_pool_id" {
  default = null
}

variable "sqlcmd_dbname" {
  default = null
}

variable "managed_identities" {
  default = null
}

variable "diagnostic_profiles" {
  default = {}
}

variable "diagnostics" {
  default = null
}
