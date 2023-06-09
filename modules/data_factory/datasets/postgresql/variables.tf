variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory Dataset"
}

variable "name" {
  description = "Name of the API Management service instance"
  type        = string
}

variable "data_factory_id" {
  description = "(Required) The Data Factory name in which to associate the Dataset with"
}

variable "linked_service_name" {
  description = "(Required) The Data Factory Linked Service name in which to associate the Dataset with"
}

variable "settings" {
  description = "Used for general parameter."
}