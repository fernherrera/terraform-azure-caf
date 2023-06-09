resource "azurerm_storage_table" "table" {
  name                 = var.settings.name
  storage_account_name = var.storage_account_name
}