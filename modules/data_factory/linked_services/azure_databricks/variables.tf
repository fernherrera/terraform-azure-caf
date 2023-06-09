variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory Linked Service."
}

variable "name" {
  description = "Name of the API Management service instance"
  type        = string
}

variable "data_factory_id" {
  description = "(Required) The Data Factory ID in which to associate the Linked Service with. Changing this forces a new resource."
}

variable "databricks_workspace_url" {
  description = "(Required) The domain URL of the databricks instance."
}

variable "databricks_workspace_id" {
  description = "(Optional) Authenticate to ADB via managed service identity."
  default     = null
}

variable "integration_runtime_name" {
  description = "(Optional) The integration runtime reference to associate with the Data Factory Linked Service Databricks."
  default     = null
}

variable "settings" {
  description = "(Required) Used to handle passthrough paramenters."
}
