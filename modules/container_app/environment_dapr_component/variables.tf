variable "container_app_environment_id" {
  description = "(Required) The ID of the Container App Managed Environment for this Dapr Component. Changing this forces a new resource to be created."
}

variable "name" {
  description = "(Required) The name for this Dapr component. Changing this forces a new resource to be created."
}

variable "type" {
  description = "(Required) The Dapr Component Type. For example state.azure.blobstorage. Changing this forces a new resource to be created."
}

variable "version" {
  description = "(Required) The version of the component."
}

variable "ignore_errors" {
  description = "(Optional) Should the Dapr sidecar to continue initialisation if the component fails to load. Defaults to false"
  default     = false
}

variable "init_timeout" {
  description = "The timeout for component initialisation as a ISO8601 formatted string. e.g. 5s, 2h, 1m. Defaults to 5s"
  default     = "5s"
}

variable "metadata" {
  description = "(Optional) One or more metadata blocks."
  default     = null
}

variable "scopes" {
  description = "(Optional) A list of scopes to which this component applies."
  default     = null
}

variable "secret" {
  description = "(Optional) A secret block."
  default     = null
}