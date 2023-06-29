#-------------------------------
# Local Declarations
#-------------------------------
locals {
  eventhub_name                  = try(var.eventhub_name, null)
  eventhub_authorization_rule_id = try(var.eventhub_authorization_rule_id, null)
  log_analytics_workspace_id     = try(var.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(var.log_analytics_destination_type, null)
  partner_solution_id            = try(var.partner_solution_id, null)
  storage_account_id             = try(var.storage_account_id, null)
}

#----------------------------------------------------------
# Azure Monitor Diagnostic Setting
#----------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "diagnostics" {

  name               = var.name
  target_resource_id = var.target_resource_id

  eventhub_name                  = local.eventhub_name
  eventhub_authorization_rule_id = local.eventhub_authorization_rule_id

  log_analytics_workspace_id     = local.log_analytics_workspace_id
  log_analytics_destination_type = local.log_analytics_destination_type

  storage_account_id = local.storage_account_id

  partner_solution_id = local.partner_solution_id

  dynamic "enabled_log" {
    for_each = lookup(var.diagnostics_definition[var.diagnostics_definition_key].categories, "enabled_log", {})

    content {
      category = enabled_log.value[0]

      dynamic "retention_policy" {
        for_each = length(enabled_log.value) > 2 ? [1] : []

        content {
          enabled = enabled_log.value[2]
          days    = enabled_log.value[3]
        }
      }
    }
  }

  dynamic "log" {
    for_each = lookup(var.diagnostics_definition[var.diagnostics_definition_key].categories, "log", {})

    content {
      category = log.value[0]
      enabled  = log.value[1]

      dynamic "retention_policy" {
        for_each = length(log.value) > 2 ? [1] : []

        content {
          enabled = log.value[2]
          days    = log.value[3]
        }
      }
    }
  }

  dynamic "metric" {
    for_each = lookup(var.diagnostics_definition[var.diagnostics_definition_key].categories, "metric", {})

    content {
      category = metric.value[0]
      enabled  = metric.value[1]

      dynamic "retention_policy" {
        for_each = length(metric.value) > 2 ? [1] : []

        content {
          enabled = metric.value[2]
          days    = metric.value[3]
        }
      }
    }
  }
}