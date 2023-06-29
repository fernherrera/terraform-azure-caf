module "diagnostic_settings" {
  source   = "../monitor/diagnostic_settings"
  for_each = var.diagnostic_settings

  name               = each.value.name
  target_resource_id = each.value.target_resource_id

  diagnostics_definition     = try(each.value.diagnostics_definition, null)
  diagnostics_definition_key = "log_analytics"

  eventhub_name                  = try(each.value.eventhub_name, null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, null)

  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, null)
  log_analytics_destination_type = try(each.value.log_analytics_destination_type, null)

  partner_solution_id = try(each.value.partner_solution_id, null)
  storage_account_id  = try(each.value.storage_account_id, null)
}