variable "name" {
  description = "(Required) Specifies the name of the Diagnostic Setting."
}

variable "target_resource_id" {
  description = "(Required) The ID of an existing Resource on which to configure Diagnostic Settings."
}

variable "eventhub_name" {
  description = "Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent."
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "(Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
  default     = null
}

variable "enabled_log" {
  description = "(Optional) One or more enabled_log blocks"
  default     = {}
}

variable "log" {
  description = "(Optional) One or more log blocks."
  default     = {}
}

variable "log_analytics_destination_type" {
  description = "(Optional) Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "metric" {
  description = "(Optional) One or more metric blocks."
  default     = {}
}

variable "partner_solution_id" {
  description = "(Optional) The ID of the market partner solution where Diagnostics Data should be sent."
  default     = null
}

variable "storage_account_id" {
  description = "(Optional) The ID of the Storage Account where logs should be sent."
  default     = null
}

######

variable "diagnostics_definition_key" {
  description = "(Required) Map key for one of the pre-defined categories."
}

variable "diagnostics_definition" {
  description = "(Required) Pre-defined Azure Monitor Diagnostics Categories list."
  default = {

    app_service = {
      name = "operational_logs_and_metrics"
      categories = {
        log = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AppServiceHTTPLogs", true, false, 7],
          ["AppServiceConsoleLogs", true, false, 7],
          ["AppServiceAppLogs", true, false, 7],
          ["AppServiceAuditLogs", true, false, 7],
          ["AppServiceIPSecAuditLogs", true, false, 7],
          ["AppServicePlatformLogs", true, false, 7],
        ]
        metric = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AllMetrics", true, false, 7],
        ]
      }
    },

    azure_data_factory = {
      name = "operational_logs_and_metrics"
      categories = {
        log = [
          # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["ActivityRuns", true, false, 7],
          ["PipelineRuns", true, false, 7],
          ["TriggerRuns", true, false, 7],
          ["SandboxPipelineRuns", true, false, 7],
          ["SandboxActivityRuns", true, false, 7],
          ["SSISPackageEventMessages", true, false, 7],
          ["SSISPackageExecutableStatistics", true, false, 7],
          ["SSISPackageEventMessageContext", true, false, 7],
          ["SSISPackageExecutionComponentPhases", true, false, 7],
          ["SSISPackageExecutionDataStatistics", true, false, 7],
          ["SSISIntegrationRuntimeLogs", true, false, 7],
        ]
        metric = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AllMetrics", true, false, 7],
        ]
      }
    },

    event_hub_namespace = {
      name = "operational_logs_and_metrics"
      categories = {
        log = [
          # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["ArchiveLogs", true, false, 7],
          ["OperationalLogs", true, false, 7],
          ["AutoScaleLogs", true, false, 7],
          ["KafkaCoordinatorLogs", true, false, 7],
          ["KafkaUserErrorLogs", true, false, 7],
          ["EventHubVNetConnectionEvent", true, false, 7],
          ["CustomerManagedKeyUserLogs", true, false, 7],
        ]
        metric = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AllMetrics", true, false, 7],
        ]
      }
    },

    keyvault = {
      name = "operational_logs_and_metrics"
      categories = {
        log = [
          # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AuditEvent", true, false, 14],
          ["AzurePolicyEvaluationDetails", true, false, 14],
        ]
        metric = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AllMetrics", true, false, 7],
        ]
      }
    },

    log_analytics = {
      name = "operational_logs_and_metrics"
      categories = {
        log = [
          # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["Audit", true, false, 7],
        ]
        metric = [
          #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
          ["AllMetrics", true, false, 7],
        ]
      }
    },

  }
}

