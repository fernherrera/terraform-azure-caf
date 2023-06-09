#---------------------------------
# Local declarations
#---------------------------------
locals {
  databases = [
    for key, value in var.settings.databases : var.databases[value.database_key].id
  ]
}

#---------------------------------
# Failover Group
#---------------------------------
resource "azurerm_sql_failover_group" "failover_group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  server_name         = var.primary_server_name
  databases           = local.databases

  partner_servers {
    id = var.secondary_server_id
  }

  read_write_endpoint_failover_policy {
    mode          = var.settings.read_write_endpoint_failover_policy.mode
    grace_minutes = var.settings.read_write_endpoint_failover_policy.mode == "Automatic" ? var.settings.read_write_endpoint_failover_policy.grace_minutes : null
  }

  dynamic "readonly_endpoint_failover_policy" {
    for_each = lookup(var.settings, "readonly_endpoint_failover_policy", {}) == {} ? [] : [1]

    content {
      mode = var.settings.readonly_endpoint_failover_policy.mode
    }
  }
}