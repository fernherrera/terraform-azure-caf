#----------------------------------------------------------
# Container App Environment Certificate
#----------------------------------------------------------
resource "azurerm_container_app_environment_certificate" "cacc" {
  name                         = var.name
  container_app_environment_id = var.container_app_environment_id
  certificate_blob_base64      = var.certificate_blob_base64
  certificate_password         = var.certificate_password
  tags                         = var.tags
}