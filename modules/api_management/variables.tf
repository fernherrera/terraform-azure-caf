variable "resource_group_name" {
  description = "(Required) The name of the Resource Group in which the API Management Service should be exist."
}

variable "location" {
  description = "(Required) The Azure location where the API Management Service exists."
}

variable "tags" {
  description = "(Optional) A mapping of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "(Required) The name of the API Management Service."
  type        = string
}

variable "sku_name" {
  description = "(Required) String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity"
  type        = string
  default     = "Basic_1"
}

variable "publisher_name" {
  description = "(Required) The name of publisher/company."
  type        = string
}

variable "publisher_email" {
  description = "(Required) The email of publisher/company."
  type        = string
}

variable "additional_location" {
  description = "List of the name of the Azure Region in which the API Management Service should be expanded to."
  type        = list(map(string))
  default     = []
}

variable "zones" {
  description = "(Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "client_certificate_enabled" {
  description = "(Optional) Enforce a client certificate to be presented on each request to the gateway? This is only supported when SKU type is `Consumption`."
  type        = bool
  default     = false
}

variable "certificate_configuration" {
  description = "List of certificate configurations"
  type        = list(map(string))
  default     = []
}

variable "gateway_disabled" {
  description = "(Optional) Disable the gateway in main region? This is only supported when `additional_location` is set."
  type        = bool
  default     = false
}

variable "min_api_version" {
  description = "(Optional) The version which the control plane API calls to API Management service are limited with version equal to or newer than."
  type        = string
  default     = null
}

variable "enable_http2" {
  description = "Should HTTP/2 be supported by the API Management Service?"
  type        = bool
  default     = false
}

variable "notification_sender_email" {
  description = "Email address from which the notification will be sent"
  type        = string
  default     = null
}

variable "enable_sign_in" {
  description = "Should anonymous users be redirected to the sign in page?"
  type        = bool
  default     = false
}

variable "enable_sign_up" {
  description = "Can users sign up on the development portal?"
  type        = bool
  default     = false
}

variable "management_hostname_configuration" {
  description = "List of management hostname configurations"
  type        = list(map(string))
  default     = []
}

variable "scm_hostname_configuration" {
  description = "List of scm hostname configurations"
  type        = list(map(string))
  default     = []
}

variable "proxy_hostname_configuration" {
  description = "List of proxy hostname configurations"
  type        = list(map(string))
  default     = []
}

variable "portal_hostname_configuration" {
  description = "Legacy portal hostname configurations"
  type        = list(map(string))
  default     = []
}

variable "developer_portal_hostname_configuration" {
  description = "Developer portal hostname configurations"
  type        = list(map(string))
  default     = []
}

variable "policy_configuration" {
  description = "Map of policy configuration"
  type        = map(string)
  default     = {}
}

variable "terms_of_service_configuration" {
  description = "Map of terms of service configuration"
  type        = list(map(string))
  nullable    = false
  default = [{
    consent_required = false
    enabled          = false
    text             = ""
  }]
}

variable "security_configuration" {
  description = "Map of security configuration"
  type        = map(string)
  default     = {}
}

variable "redis_cache_configuration" {
  description = "Map of redis cache configurations"
  default     = {}
}

### IDENTITY

variable "identity_type" {
  description = "Type of Managed Service Identity that should be configured on this API Management Service"
  type        = string
  default     = "SystemAssigned"
  nullable    = false
}

variable "identity_ids" {
  description = "A list of IDs for User Assigned Managed Identity resources to be assigned. This is required when type is set to UserAssigned or SystemAssigned, UserAssigned."
  type        = list(string)
  default     = []
}

variable "named_values" {
  description = "Map containing the name of the named values as key and value as values"
  type        = list(map(string))
  default     = []
}

variable "products" {
  description = "List of products to create"
  type        = list(string)
  default     = []
}

variable "create_product_group_and_relationships" {
  description = "Create local APIM groups with name identical to products and create a relationship between groups and products"
  type        = bool
  default     = false
}

### NETWORKING

variable "virtual_network_type" {
  description = "The type of virtual network you want to use, valid values include: None, External, Internal."
  type        = string
  default     = null
}

variable "virtual_network_configuration" {
  description = "The id(s) of the subnet(s) that will be used for the API Management. Required when virtual_network_type is External or Internal"
  default     = null
}

variable "subnets" {
  description = "Virtual subnet networks configuration object"
}