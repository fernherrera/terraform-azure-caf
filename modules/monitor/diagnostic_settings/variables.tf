variable "name" {
  description = "(Required) Specifies the name of the Diagnostic Setting."
}

variable "target_resource_id" {
  description = "(Required) The ID of an existing Resource on which to configure Diagnostic Settings."
}

variable "eventhub_name" {
  description = "(Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent."
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "(Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "log_analytics_destination_type" {
  description = "(Optional) Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
  default     = null
}

variable "partner_solution_id" {
  description = "(Optional) The ID of the market partner solution where Diagnostics Data should be sent."
  default     = null
}

variable "storage_account_id" {
  description = "(Optional) The ID of the Storage Account where logs should be sent."
  default     = null
}

variable "enabled_log" {
  description = "(Optional) One or more enabled_log blocks."
  default     = []
}

variable "log" {
  description = "(Optional) One or more log blocks."
  default     = []
}

variable "metric" {
  description = "(Optional) One or more metric blocks."
  default     = []
}