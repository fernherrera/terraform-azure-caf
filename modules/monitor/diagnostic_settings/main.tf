#----------------------------------------------------------
# Local Declarations
#----------------------------------------------------------
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

  name                           = var.name
  target_resource_id             = var.target_resource_id
  eventhub_name                  = local.eventhub_name
  eventhub_authorization_rule_id = local.eventhub_authorization_rule_id
  log_analytics_workspace_id     = local.log_analytics_workspace_id
  log_analytics_destination_type = local.log_analytics_destination_type
  storage_account_id             = local.storage_account_id
  partner_solution_id            = local.partner_solution_id

  dynamic "enabled_log" {
    for_each = try(var.enabled_log, [])

    content {
      category       = enabled_log.value.category
      category_group = try(enabled_log.value.category_group, null)

      dynamic "retention_policy" {
        for_each = try(enabled_log.value.retention_policy, null) != null ? [1] : []

        content {
          enabled = enabled_log.value.retention_policy.enabled
          days    = try(enabled_log.value.retention_policy.days, 0)
        }
      }
    }
  }

  dynamic "log" {
    for_each = try(var.log, [])

    content {
      category = log.value.category
      enabled  = try(log.value.enabled, true)

      dynamic "retention_policy" {
        for_each = try(log.value.retention_policy, null) != null ? [1] : []

        content {
          enabled = log.value.retention_policy.enabled
          days    = try(log.value.retention_policy.days, 0)
        }
      }
    }
  }

  dynamic "metric" {
    for_each = try(var.metric, [])

    content {
      category = metric.value.category
      enabled  = try(metric.value.enabled, true)

      dynamic "retention_policy" {
        for_each = try(metric.value.retention_policy, null) != null ? [1] : []

        content {
          enabled = metric.value.retention_policy.enabled
          days    = try(metric.value.retention_policy.days, 0)
        }
      }
    }
  }
}