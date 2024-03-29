variable "name" {
  description = "(Required) The name of the Application Gateway. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to the Application Gateway should exist. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) The Azure region where the Application Gateway should exist. Changing this forces a new resource to be created."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "virtual_network_name" {
  description = "(Optional) The name of the virtual network"
  default     = ""
}

variable "vnet_resource_group_name" {
  description = "(Optional) The resource group name where the virtual network is created"
  default     = null
}

variable "subnet_name" {
  description = "(Optional) The name of the subnet to use in VM scale set"
  default     = ""
}

variable "log_analytics_workspace_name" {
  description = "(Optional) The name of log analytics workspace name"
  default     = null
}

variable "storage_account_name" {
  description = "(Optional) The name of the hub storage account to store logs"
  default     = null
}

variable "domain_name_label" {
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN."
  default     = null
}

variable "backend_address_pools" {
  description = "(Required) One or more backend_address_pool blocks."
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "(Required) One or more backend_http_settings blocks."
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    affinity_cookie_name                = optional(string)
    path                                = optional(string)
    enable_https                        = bool
    probe_name                          = optional(string)
    request_timeout                     = number
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    authentication_certificate = optional(object({
      name = string
    }))
    trusted_root_certificate_names = optional(list(string))
    connection_draining = optional(object({
      enable_connection_draining = bool
      drain_timeout_sec          = number
    }))
  }))
}

variable "frontend_ip_configurations" {
  description = "(Required) One or more frontend_ip_configuration blocks."
}

variable "frontend_ports" {
  description = "(Required) One or more frontend_port blocks."
  default     = {}
}

variable "gateway_ip_configuration" {
  description = "(Required) One or more gateway_ip_configuration blocks."
}

variable "http_listeners" {
  description = "(Required) One or more http_listener blocks."
  type = list(object({
    name                 = string
    host_name            = optional(string)
    host_names           = optional(list(string))
    require_sni          = optional(bool)
    ssl_certificate_name = optional(string)
    firewall_policy_id   = optional(string)
    ssl_profile_name     = optional(string)
    custom_error_configuration = optional(list(object({
      status_code           = string
      custom_error_page_url = string
    })))
  }))
}

variable "fips_enabled" {
  description = "(Optional) Is FIPS enabled on the Application Gateway?"
  default     = null
}

variable "global" {
  description = "(Optional) A global block."
  default     = {}
}

variable "identity" {
  description = "(Optional) An identity block"
  default     = null
}

variable "private_link_configuration" {
  description = "(Optional) One or more private_link_configuration blocks."
  default     = {}
}

variable "request_routing_rules" {
  description = "(Required) One or more request_routing_rule blocks."
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    url_path_map_name           = optional(string)
  }))
  default = []
}

variable "sku" {
  description = "(Required) A sku block."
  type = object({
    name     = string
    tier     = string
    capacity = optional(number)
  })
}

variable "zones" {
  description = "(Optional) Specifies a list of Availability Zones in which this Application Gateway should be located. Changing this forces a new Application Gateway to be created."
  default     = []
}

variable "trusted_client_certificate" {
  description = "(Optional) One or more trusted_client_certificate blocks."
  default     = {}
}

variable "ssl_profile" {
  description = "(Optional) One or more ssl_profile blocks."
  default     = {}
}

variable "authentication_certificates" {
  description = "(Optional) One or more authentication_certificate blocks."
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "trusted_root_certificates" {
  description = "(Optional) One or more trusted_root_certificate blocks."
  type = list(object({
    name = string
    data = string
  }))
  default = []
}

variable "ssl_policy" {
  description = "(Optional) a ssl_policy block."
  type = object({
    disabled_protocols   = optional(list(string))
    policy_type          = optional(string)
    policy_name          = optional(string)
    cipher_suites        = optional(list(string))
    min_protocol_version = optional(string)
  })
  default = null
}

variable "enable_http2" {
  description = "(Optional) Is HTTP2 enabled on the application gateway resource? Defaults to false."
  default     = null
}

variable "force_firewall_policy_association" {
  description = "(Optional) Is the Firewall Policy associated with the Application Gateway?"
  default     = null
}

variable "health_probes" {
  description = "(Optional) One or more health probe blocks."
  type = list(object({
    name                                      = string
    host                                      = string
    interval                                  = number
    path                                      = string
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = optional(number)
    pick_host_name_from_backend_http_settings = optional(bool)
    minimum_servers                           = optional(number)
    match = optional(object({
      body        = optional(string)
      status_code = optional(list(string))
    }))
  }))
  default = []
}

variable "ssl_certificates" {
  description = "(Optional) One or more ssl_certificate blocks."
  type = list(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}

variable "url_path_maps" {
  description = "(Optional) One or more url_path_map blocks."
  type = list(object({
    name                                = string
    default_backend_http_settings_name  = optional(string)
    default_backend_address_pool_name   = optional(string)
    default_redirect_configuration_name = optional(string)
    default_rewrite_rule_set_name       = optional(string)
    path_rules = list(object({
      name                        = string
      backend_address_pool_name   = optional(string)
      backend_http_settings_name  = optional(string)
      paths                       = list(string)
      redirect_configuration_name = optional(string)
      rewrite_rule_set_name       = optional(string)
      firewall_policy_id          = optional(string)
    }))
  }))
  default = []
}

variable "waf_configuration" {
  description = "(Optional) A waf_configuration block."
  type = object({
    firewall_mode            = string
    rule_set_version         = string
    file_upload_limit_mb     = optional(number)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(number)
    disabled_rule_group = optional(list(object({
      rule_group_name = string
      rules           = optional(list(string))
    })))
    exclusion = optional(list(object({
      match_variable          = string
      selector_match_operator = optional(string)
      selector                = optional(string)
    })))
  })
  default = null
}

variable "custom_error_configuration" {
  description = "(Optional) One or more custom_error_configuration blocks."
  type        = list(map(string))
  default     = []
}

variable "firewall_policy_id" {
  description = "(Optional) The ID of the Web Application Firewall Policy."
  default     = null
}

variable "redirect_configuration" {
  description = "(Optional) One or more redirect_configuration blocks."
  type        = list(map(string))
  default     = []
}

variable "autoscale_configuration" {
  description = "(Optional) A autoscale_configuration block."
  type = object({
    min_capacity = number
    max_capacity = optional(number)
  })
  default = null
}

variable "rewrite_rule_set" {
  description = "(Optional) One or more rewrite_rule_set blocks. Only valid for v2 SKUs."
  type        = any
  default     = []
}

variable "agw_diag_logs" {
  description = "Application Gateway Monitoring Category details for Azure Diagnostic setting"
  type        = list(string)
  default     = ["ApplicationGatewayAccessLog", "ApplicationGatewayPerformanceLog", "ApplicationGatewayFirewallLog"]
}

variable "pip_diag_logs" {
  description = "Load balancer Public IP Monitoring Category details for Azure Diagnostic setting"
  type        = list(string)
  default     = ["DDoSProtectionNotifications", "DDoSMitigationFlowLogs", "DDoSMitigationReports"]
}