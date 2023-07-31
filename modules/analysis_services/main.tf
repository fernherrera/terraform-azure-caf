#--------------------------------------
# Analysis Services Server
#--------------------------------------
resource "azurerm_analysis_services_server" "server" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tags                      = var.tags
  sku                       = var.sku
  admin_users               = try(var.admin_users, [])
  backup_blob_container_uri = try(var.backup_blob_container_uri, null)
  enable_power_bi_service   = try(var.enable_power_bi_service, false)
  querypool_connection_mode = try(var.querypool_connection_mode, "ReadOnly")

  dynamic "ipv4_firewall_rule" {
    for_each = try(var.ipv4_firewall_rule, {})

    content {
      name        = ipv4_firewall_rule.value.name
      range_start = ipv4_firewall_rule.value.range_start
      range_end   = ipv4_firewall_rule.value.range_end
    }
  }
}