resource "azurerm_data_factory_linked_service_web" "linked_service_web" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  data_factory_id          = var.data_factory_id
  description              = try(var.settings.description, null)
  integration_runtime_name = try(var.settings.integration_runtime_name, null)
  annotations              = try(var.settings.annotations, null)
  parameters               = try(var.settings.parameters, null)
  additional_properties    = try(var.settings.additional_properties, null)
  authentication_type      = var.settings.authentication_type
  url                      = var.settings.url
}