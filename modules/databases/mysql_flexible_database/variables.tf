variable "name" {
  description = "(Required) Specifies the name of the MySQL Database, which needs to be a valid MySQL identifier."
  type        = string
}

variable "server_name" {
  description = "(Required) Specifies the name of the MySQL Flexible Server."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which the MySQL Server exists."
  type        = string
}

variable "charset" {
  description = "(Required) Specifies the Charset for the MySQL Database, which needs to be a valid MySQL Charset."
  type        = string
}

variable "collation" {
  description = "(Required) Specifies the Collation for the MySQL Database, which needs to be a valid MySQL Collation."
  type        = string
}