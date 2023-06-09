resource "azurerm_data_factory_dataset_json" "dataset" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  data_factory_id       = var.data_factory_id
  linked_service_name   = var.linked_service_name
  folder                = try(var.settings.folder, null)
  description           = try(var.settings.description, null)
  annotations           = try(var.settings.annotations, null)
  parameters            = try(var.settings.parameters, null)
  additional_properties = try(var.settings.additional_properties, null)
  encoding              = var.settings.encoding

  dynamic "http_server_location" {
    for_each = try(var.settings.http_server_location, null) != null ? [var.settings.http_server_location] : []

    content {
      relative_url = http_server_location.value.relative_url
      path         = http_server_location.value.path
      filename     = http_server_location.value.filename
    }
  }

  dynamic "azure_blob_storage_location" {
    for_each = try(var.settings.azure_blob_storage_location, null) != null ? [var.settings.azure_blob_storage_location] : []

    content {
      container = azure_blob_storage_location.value.container
      path      = azure_blob_storage_location.value.path
      filename  = azure_blob_storage_location.value.filename
    }
  }

  dynamic "schema_column" {
    for_each = try(var.settings.sche1ma_column, null) != null ? [var.settings.schema_column] : []

    content {
      name        = schema_column.value.name
      type        = lookup(schema_column.value, "type", null)
      description = lookup(schema_column.value, "description", null)
    }
  }
}