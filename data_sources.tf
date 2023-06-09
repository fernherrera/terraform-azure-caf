#--------------------------------------
# Data (existing resources)
#--------------------------------------

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

#--------------------------------------
# API Management
#--------------------------------------
data "azurerm_api_management" "apim" {
  for_each = try(var.data_sources.api_management, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

#--------------------------------------
# Key Vaults
#--------------------------------------
data "azurerm_key_vault" "kv" {
  for_each = try(var.data_sources.keyvaults, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

#--------------------------------------
# Log Analytics Workspaces
#--------------------------------------
data "azurerm_log_analytics_workspace" "law" {
  for_each = try(var.data_sources.log_analytics, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

#--------------------------------------
# Storage Accounts
#--------------------------------------
data "azurerm_storage_account" "stg" {
  for_each = try(var.data_sources.storage_accounts, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}
