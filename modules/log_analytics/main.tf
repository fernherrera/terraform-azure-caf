#-------------------------------
# Local Declarations
#-------------------------------
locals {
  id                   = element(coalescelist(data.azurerm_log_analytics_workspace.law_e.*.id, azurerm_log_analytics_workspace.law.*.id, [""]), 0)
  name                 = element(coalescelist(data.azurerm_log_analytics_workspace.law_e.*.name, azurerm_log_analytics_workspace.law.*.name, [""]), 0)
  primary_shared_key   = element(coalescelist(data.azurerm_log_analytics_workspace.law_e.*.primary_shared_key, azurerm_log_analytics_workspace.law.*.primary_shared_key, [""]), 0)
  secondary_shared_key = element(coalescelist(data.azurerm_log_analytics_workspace.law_e.*.secondary_shared_key, azurerm_log_analytics_workspace.law.*.secondary_shared_key, [""]), 0)
  workspace_id         = element(coalescelist(data.azurerm_log_analytics_workspace.law_e.*.workspace_id, azurerm_log_analytics_workspace.law.*.workspace_id, [""]), 0)
}

#----------------------------------------------------------
# Log Analytics Workspace creation or selection
#----------------------------------------------------------
data "azurerm_log_analytics_workspace" "law_e" {
  count = var.existing == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "law" {
  count = var.existing == false ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  allow_resource_only_permissions    = try(var.allow_resource_only_permissions, true)
  cmk_for_query_forced               = try(var.cmk_for_query_forced, null)
  daily_quota_gb                     = try(var.daily_quota_gb, null)
  internet_ingestion_enabled         = try(var.internet_ingestion_enabled, null)
  internet_query_enabled             = try(var.internet_query_enabled, null)
  local_authentication_disabled      = try(var.local_authentication_disabled, false)
  reservation_capacity_in_gb_per_day = var.sku == "CapacityReservation" ? try(var.reservation_capacity_in_gb_per_day, null) : null
  retention_in_days                  = try(var.retention_in_days, 30)
  sku                                = try(var.sku, "PerGB2018")
}