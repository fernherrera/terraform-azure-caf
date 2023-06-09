#----------------------------------------------------------
# Dapr Component for a Container App Environment
#----------------------------------------------------------
resource "azurerm_container_app_environment_dapr_component" "dc" {
  name                         = var.name
  container_app_environment_id = var.container_app_environment_id
  component_type               = var.type
  version                      = var.version
  ignore_errors                = try(var.ignore_errors, false)
  init_timeout                 = try(var.init_timeout, "5s")
  scopes                       = try(var.scopes, [])

  dynamic "metadata" {
    for_each = try(var.metadata, {})

    content {
      name        = metadata.value.name
      secret_name = metadata.value.secret_name
      value       = metadata.value.value
    }
  }
}