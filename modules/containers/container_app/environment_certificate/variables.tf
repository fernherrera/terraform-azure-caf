variable "name" {
  description = "(Required) The name of the Container Apps Environment Certificate. Changing this forces a new resource to be created."
}

variable "container_app_environment_id" {
  description = "(Required) The Container App Managed Environment ID to configure this Certificate on. Changing this forces a new resource to be created."
}

variable "certificate_blob_base64" {
  description = "(Required) The Certificate Private Key as a base64 encoded PFX or PEM. Changing this forces a new resource to be created."
}

variable "certificate_password" {
  description = "(Required) The password for the Certificate. Changing this forces a new resource to be created."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}