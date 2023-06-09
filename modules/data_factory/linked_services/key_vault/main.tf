resource "azurerm_data_factory_linked_service_key_vault" "linked_service_key_vault" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  data_factory_id          = var.data_factory_id
  description              = var.description
  integration_runtime_name = var.integration_runtime_name
  annotations              = var.annotations
  parameters               = var.parameters
  additional_properties    = var.additional_properties
  key_vault_id             = var.key_vault_id
}