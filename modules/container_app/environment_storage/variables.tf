variable "name" {
  description = "(Required) The name for this Container App Environment Storage. Changing this forces a new resource to be created."
}

variable "container_app_environment_id" {
  description = "(Required) The ID of the Container App Environment to which this storage belongs. Changing this forces a new resource to be created."
}

variable "account_name" {
  description = "(Required) The Azure Storage Account in which the Share to be used is located. Changing this forces a new resource to be created."
}

variable "access_key" {
  description = "(Required) The Storage Account Access Key."
}

variable "share_name" {
  description = "(Required) The name of the Azure Storage Share to use. Changing this forces a new resource to be created."
}

variable "access_mode" {
  description = "(Required) The access mode to connect this storage to the Container App. Possible values include ReadOnly and ReadWrite. Changing this forces a new resource to be created."
}
