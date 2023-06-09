#---------------------------------
# Local declarations
#---------------------------------
locals {
  name = var.name
  tags = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Container App Environment Certificate
#----------------------------------------------------------
resource "azurerm_container_app_environment_certificate" "cacc" {
  name                         = local.name
  container_app_environment_id = var.container_app_environment_id
  certificate_blob             = var.certificate_blob
  certificate_password         = var.certificate_password
}