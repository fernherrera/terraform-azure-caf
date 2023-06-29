# Last reviewed :  AzureRM version 2.64.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule

#--------------------------------------
# Event Hub
#--------------------------------------
resource "azurerm_eventhub" "evhub" {
  name                = var.name
  namespace_name      = var.namespace_name
  resource_group_name = var.resource_group_name
  partition_count     = var.partition_count
  message_retention   = var.message_retention
  status              = try(var.status, null)

  dynamic "capture_description" {
    for_each = try(var.capture_description, {}) == {} ? [] : [1]

    content {
      enabled             = var.capture_description.enabled
      encoding            = var.capture_description.encoding
      interval_in_seconds = try(var.capture_description.interval_in_seconds, null)
      size_limit_in_bytes = try(var.capture_description.size_limit_in_bytes, null)
      skip_empty_archives = try(var.capture_description.skip_empty_archives, null)

      dynamic "destination" { # required if capture_description is set
        for_each = try(var.capture_description.destination, {}) == {} ? [] : [1]

        content {
          name                = var.capture_description.destination.name                # At this time(12/2020), the only supported value is EventHubArchive.AzureBlockBlob
          archive_name_format = var.capture_description.destination.archive_name_format # e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}
          blob_container_name = var.capture_description.destination.blob_container_name
          storage_account_id  = var.storage_account_id
        }
      }
    }
  }
}