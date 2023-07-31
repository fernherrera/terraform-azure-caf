#--------------------------------------
# Storage Sync 
#--------------------------------------
resource "azurerm_storage_sync" "sync" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  incoming_traffic_policy = var.incoming_traffic_policy

  lifecycle {
    # Hack to ignore location, since getting the location from the resource group seems to trigger a destroy/recreate.
    ignore_changes = [location]
  }
}

#--------------------------------------
# Storage Sync Group
#--------------------------------------
resource "azurerm_storage_sync_group" "sync_group" {
  for_each   = toset(var.sync_groups)
  depends_on = [azurerm_storage_sync.sync]

  name            = each.key
  storage_sync_id = azurerm_storage_sync.sync.id
}

#--------------------------------------
# Storage Sync Cloud Endpoint
#--------------------------------------
resource "azurerm_storage_sync_cloud_endpoint" "cloud_endpoint" {
  for_each   = try(var.cloud_endpoints, {})
  depends_on = [azurerm_storage_sync_group.sync_group]

  name                      = each.value.name
  file_share_name           = each.value.file_share_name
  storage_sync_group_id     = can(each.value.storage_sync_group_id) ? each.value.storage_sync_group_id : try(azurerm_storage_sync_group.sync_group[each.value.storage_sync_group_key].id, null)
  storage_account_id        = can(each.value.storage_account_id) ? each.value.storage_account_id : try(var.storage_accounts[each.value.storage_account_key].id, null)
  storage_account_tenant_id = try(each.value.storage_account_tenant_id, null)
}