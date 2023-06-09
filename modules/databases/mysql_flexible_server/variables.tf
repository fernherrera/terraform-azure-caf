variable "name" {
  description = "(Required) The name which should be used for this MySQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group where the MySQL Flexible Server should exist."
  type        = string
}

variable "location" {
  description = "(Required) The Azure Region where the MySQL Flexible Server should exist."
  type        = string
}

variable "tags" {
  description = "(Optional) A mapping of tags which should be assigned to the MySQL Flexible Server."
  type        = map(string)
  default     = {}
}

variable "administrator_login" {
  description = "(Optional) The Administrator login for the MySQL Flexible Server. Required when create_mode is Default."
  default     = null
}

variable "administrator_password" {
  description = "(Optional) The Password associated with the administrator_login for the MySQL Flexible Server. Required when create_mode is Default."
  default     = null
}

variable "backup_retention_days" {
  description = "Optional) The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7."
  default     = 7
}

variable "create_mode" {
  description = "(Optional)The creation mode which can be used to restore or replicate existing servers. Possible values are Default, PointInTimeRestore, GeoRestore, and Replica."
  default     = "Default"
}

variable "customer_managed_key" {
  description = "(Optional) A customer_managed_key block."
  default     = {}
}

variable "delegated_subnet_id" {
  description = "(Optional) The ID of the virtual network subnet to create the MySQL Flexible Server."
  default     = null
}

variable "geo_redundant_backup_enabled" {
  description = "(Optional) Should geo redundant backup enabled? Defaults to false."
  default     = false
}

variable "high_availability" {
  description = "(Optional) A high_availability block."
  default     = {}
}

variable "identity" {
  description = "(Optional) An identity block."
  default     = {}
}

variable "maintenance_window" {
  description = "(Optional) A maintenance_window block."
  default     = {}
}

variable "point_in_time_restore_time_in_utc" {
  description = "(Optional) The point in time to restore from creation_source_server_id when create_mode is PointInTimeRestore."
  default     = null
}

variable "private_dns_zone_id" {
  description = "(Optional) The ID of the private DNS zone to create the MySQL Flexible Server."
  default     = null
}

variable "replication_role" {
  description = "(Optional) The replication role. Possible value is None."
  default     = null
}

variable "sku_name" {
  description = "(Optional) The SKU Name for the MySQL Flexible Server.  sku_name should start with SKU tier B (Burstable), GP (General Purpose), MO (Memory Optimized) like B_Standard_B1s."
  default     = null
}

variable "source_server_id" {
  description = "(Optional)The resource ID of the source MySQL Flexible Server to be restored. Required when create_mode is PointInTimeRestore, GeoRestore, and Replica."
  default     = null
}

variable "storage" {
  description = "(Optional) A storage block."
  default     = {}
}

variable "mysql_version" {
  description = "(Optional) The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21."
  default     = null
}

variable "zone" {
  description = "(Optional) Specifies the Availability Zone in which this MySQL Flexible Server should be located. Possible values are 1, 2 and 3."
  default     = null
}

variable "firewall_rules" {
  description = "(Optional) A list of firewall rule objects."
  default     = []
}