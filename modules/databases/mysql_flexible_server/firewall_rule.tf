#--------------------------------------
# SQL Server firewall rules
#--------------------------------------
resource "azurerm_mysql_flexible_server_firewall_rule" "fwRules" {
  for_each = { for i in var.firewall_rules : i.name => i }

  name                = each.value.name
  server_name         = azurerm_mysql_flexible_server.server.name
  resource_group_name = local.resource_group_name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}