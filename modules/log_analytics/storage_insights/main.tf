#-------------------------------
# Log Analytics Storage Insights resource creation
#-------------------------------

resource "azurerm_log_analytics_storage_insights" "lasi" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  workspace_id         = var.workspace_id
  storage_account_id   = var.storage_account_id
  storage_account_key  = var.primary_access_key
  blob_container_names = try(var.settings.blob_container_names, null)
  table_names          = try(var.settings.table_names, null)
}