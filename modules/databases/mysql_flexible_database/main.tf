#--------------------------------------
# MySQL Server database
#--------------------------------------
resource "azurerm_mysql_flexible_database" "db" {
  name                = var.name
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  charset             = var.charset
  collation           = var.collation
}
