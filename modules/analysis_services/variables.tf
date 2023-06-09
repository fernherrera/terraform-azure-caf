variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the Analysis Services Server should be exist."
  default     = ""
}

variable "location" {
  description = "(Required) The Azure location where the Analysis Services Server exists."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) The name of the Analysis Services Server. Only lowercase Alphanumeric characters allowed, starting with a letter."
  type        = string
}

variable "sku" {
  description = "(Required) SKU for the Analysis Services Server. Possible values are: D1, B1, B2, S0, S1, S2, S4, S8, S9, S8v2 and S9v2."
}

variable "admin_users" {
  description = "(Optional) List of email addresses of admin users."
  default     = []
}

variable "querypool_connection_mode" {
  description = "(Optional) Controls how the read-write server is used in the query pool. If this value is set to All then read-write servers are also used for queries. Otherwise with ReadOnly these servers do not participate in query operations."
  default     = "ReadOnly"
}

variable "backup_blob_container_uri" {
  description = "(Optional) URI and SAS token for a blob container to store backups."
  default     = null
}

variable "enable_power_bi_service" {
  description = "(Optional) Indicates if the Power BI service is allowed to access or not."
  default     = false
}

variable "ipv4_firewall_rule" {
  description = "(Optional) One or more ipv4_firewall_rule block(s)."
  default     = {}
}