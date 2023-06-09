<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostics_definition"></a> [diagnostics\_definition](#input\_diagnostics\_definition) | (Required) Pre-defined Azure Monitor Diagnostics Categories list. | `map` | <pre>{<br>  "app_service": {<br>    "categories": {<br>      "log": [<br>        [<br>          "AppServiceHTTPLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "AppServiceConsoleLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "AppServiceAppLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "AppServiceAuditLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "AppServiceIPSecAuditLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "AppServicePlatformLogs",<br>          true,<br>          false,<br>          7<br>        ]<br>      ],<br>      "metric": [<br>        [<br>          "AllMetrics",<br>          true,<br>          false,<br>          7<br>        ]<br>      ]<br>    },<br>    "name": "operational_logs_and_metrics"<br>  },<br>  "azure_data_factory": {<br>    "categories": {<br>      "log": [<br>        [<br>          "ActivityRuns",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "PipelineRuns",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "TriggerRuns",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SandboxPipelineRuns",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SandboxActivityRuns",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SSISPackageEventMessages",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SSISPackageExecutableStatistics",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SSISPackageEventMessageContext",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SSISPackageExecutionComponentPhases",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SSISPackageExecutionDataStatistics",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "SSISIntegrationRuntimeLogs",<br>          true,<br>          false,<br>          7<br>        ]<br>      ],<br>      "metric": [<br>        [<br>          "AllMetrics",<br>          true,<br>          false,<br>          7<br>        ]<br>      ]<br>    },<br>    "name": "operational_logs_and_metrics"<br>  },<br>  "event_hub_namespace": {<br>    "categories": {<br>      "log": [<br>        [<br>          "ArchiveLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "OperationalLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "AutoScaleLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "KafkaCoordinatorLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "KafkaUserErrorLogs",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "EventHubVNetConnectionEvent",<br>          true,<br>          false,<br>          7<br>        ],<br>        [<br>          "CustomerManagedKeyUserLogs",<br>          true,<br>          false,<br>          7<br>        ]<br>      ],<br>      "metric": [<br>        [<br>          "AllMetrics",<br>          true,<br>          false,<br>          7<br>        ]<br>      ]<br>    },<br>    "name": "operational_logs_and_metrics"<br>  },<br>  "keyvault": {<br>    "categories": {<br>      "log": [<br>        [<br>          "AuditEvent",<br>          true,<br>          false,<br>          14<br>        ],<br>        [<br>          "AzurePolicyEvaluationDetails",<br>          true,<br>          false,<br>          14<br>        ]<br>      ],<br>      "metric": [<br>        [<br>          "AllMetrics",<br>          true,<br>          false,<br>          7<br>        ]<br>      ]<br>    },<br>    "name": "operational_logs_and_metrics"<br>  },<br>  "log_analytics": {<br>    "categories": {<br>      "log": [<br>        [<br>          "Audit",<br>          true,<br>          false,<br>          7<br>        ]<br>      ],<br>      "metric": [<br>        [<br>          "AllMetrics",<br>          true,<br>          false,<br>          7<br>        ]<br>      ]<br>    },<br>    "name": "operational_logs_and_metrics"<br>  }<br>}</pre> | no |
| <a name="input_diagnostics_definition_key"></a> [diagnostics\_definition\_key](#input\_diagnostics\_definition\_key) | (Required) Map key for one of the pre-defined categories. | `any` | n/a | yes |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | (Optional) One or more enabled\_log blocks | `map` | `{}` | no |
| <a name="input_eventhub_authorization_rule_id"></a> [eventhub\_authorization\_rule\_id](#input\_eventhub\_authorization\_rule\_id) | (Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | `any` | `null` | no |
| <a name="input_eventhub_name"></a> [eventhub\_name](#input\_eventhub\_name) | Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent. | `any` | `null` | no |
| <a name="input_log"></a> [log](#input\_log) | (Optional) One or more log blocks. | `map` | `{}` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `any` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. | `any` | `null` | no |
| <a name="input_metric"></a> [metric](#input\_metric) | (Optional) One or more metric blocks. | `map` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Diagnostic Setting. | `any` | n/a | yes |
| <a name="input_partner_solution_id"></a> [partner\_solution\_id](#input\_partner\_solution\_id) | (Optional) The ID of the market partner solution where Diagnostics Data should be sent. | `any` | `null` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | (Optional) The ID of the Storage Account where logs should be sent. | `any` | `null` | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | (Required) The ID of an existing Resource on which to configure Diagnostic Settings. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Diagnostic Setting. |
<!-- END_TF_DOCS -->