#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = local.tags
}

#--------------------------------------
# Storage Sync Resource Creation
#--------------------------------------
resource "azurerm_storage_sync" "sync" {
  name                    = var.name
  resource_group_name     = local.resource_group_name
  location                = local.location
  incoming_traffic_policy = var.incoming_traffic_policy

  lifecycle {
    # Hack to ignore location, since getting the location from the resource group seems to trigger a destroy/recreate.
    ignore_changes = [location]
  }
}

resource "azurerm_storage_sync_group" "sync_group" {
  for_each   = toset(var.sync_groups)
  depends_on = [azurerm_storage_sync.sync]

  name            = each.key
  storage_sync_id = azurerm_storage_sync.sync.id
}

resource "azurerm_storage_sync_cloud_endpoint" "cloud_endpoint" {
  for_each   = try(var.cloud_endpoints, {})
  depends_on = [azurerm_storage_sync_group.sync_group]

  name                      = each.value.name
  file_share_name           = each.value.file_share_name
  storage_sync_group_id     = can(each.value.storage_sync_group_id) ? each.value.storage_sync_group_id : try(azurerm_storage_sync_group.sync_group[each.value.storage_sync_group_key].id, null)
  storage_account_id        = can(each.value.storage_account_id) ? each.value.storage_account_id : try(var.storage_accounts[each.value.storage_account_key].id, null)
  storage_account_tenant_id = try(each.value.storage_account_tenant_id, null)
}

