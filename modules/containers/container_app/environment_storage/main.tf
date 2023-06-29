#----------------------------------------------------------
# Container App Environment Storage
#----------------------------------------------------------
resource "azurerm_container_app_environment_storage" "caes" {
  name                         = var.name
  container_app_environment_id = var.container_app_environment_id
  account_name                 = var.account_name
  share_name                   = var.share_name
  access_key                   = var.access_key
  access_mode                  = var.access_mode
}