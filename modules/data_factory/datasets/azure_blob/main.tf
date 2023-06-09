resource "azurerm_data_factory_dataset_azure_blob" "dataset" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  data_factory_id       = var.data_factory_id
  linked_service_name   = var.linked_service_name
  folder                = try(var.settings.folder, null)
  description           = try(var.settings.description, null)
  annotations           = try(var.settings.annotations, null)
  parameters            = try(var.settings.parameters, null)
  additional_properties = try(var.settings.additional_properties, null)
  path                  = var.settings.path
  filename              = var.settings.filename

  dynamic "schema_column" {
    for_each = try(var.settings.schema_column, null) != null ? [var.settings.schema_column] : []

    content {
      name        = schema_column.value.name
      type        = lookup(schema_column.value, "type", null)
      description = lookup(schema_column.value, "description", null)
    }
  }
}