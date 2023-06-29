module "event_hubs" {
  source   = "../hubs"
  for_each = try(var.event_hubs, {})

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.evh.name
  resource_group_name = local.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
  capture_description = try(each.value.capture_description, {})
  status              = try(each.value.status, null)
  storage_account_id  = try(var.storage_accounts[each.value.storage_account_key].id, null)
}