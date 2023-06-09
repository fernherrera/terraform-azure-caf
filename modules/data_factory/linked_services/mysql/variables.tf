variable "name" {
  description = "(Required) Specifies the name of the Data Factory Linked Service Key Vault. Changing this forces a new resource to be created. Must be globally unique."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory Linked Service."
}

variable "data_factory_id" {
  description = "(Required) The Data Factory ID in which to associate the Linked Service with. Changing this forces a new resource."
}

variable "settings" {
  description = "Used for general parameter."
}
