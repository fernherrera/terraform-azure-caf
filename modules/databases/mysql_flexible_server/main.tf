#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#--------------------------------------
# MYSQL Server
#--------------------------------------
resource "azurerm_mysql_flexible_server" "server" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  administrator_login               = try(var.administrator_login, null)
  administrator_password            = try(var.administrator_password, null)
  backup_retention_days             = try(var.backup_retention_days, 7)
  create_mode                       = try(var.create_mode, "Default")
  delegated_subnet_id               = try(var.delegated_subnet_id, null)
  geo_redundant_backup_enabled      = try(var.geo_redundant_backup_enabled, false)
  private_dns_zone_id               = try(var.private_dns_zone_id, null)
  replication_role                  = try(var.replication_role, null)
  sku_name                          = try(var.sku_name, null)
  source_server_id                  = try(var.source_server_id, null)
  point_in_time_restore_time_in_utc = try(var.point_in_time_restore_time_in_utc, null)
  version                           = try(var.mysql_version, null)
  zone                              = try(var.zone, null)


  dynamic "customer_managed_key" {
    for_each = try(var.customer_managed_key, {}) != {} ? [1] : []

    content {
      key_vault_key_id                  = try(var.customer_managed_key.key_vault_key_id, null)
      primary_user_assigned_identity_id = try(var.customer_managed_key.primary_user_assigned_identity_id, null)
    }
  }

  dynamic "high_availability" {
    for_each = try(var.high_availability, {}) != {} ? [1] : []

    content {
      mode                      = try(var.high_availability.mode, "SameZone")
      standby_availability_zone = try(var.high_availability.standby_availability_zone, 1)
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, {})

    content {
      type         = local.identity_type
      identity_ids = local.managed_identities
    }
  }

  dynamic "maintenance_window" {
    for_each = try(var.maintenance_window, {}) != {} ? [1] : []

    content {
      day_of_week  = try(var.maintenance_window.day_of_week, 0)
      start_hour   = try(var.maintenance_window.start_hour, 0)
      start_minute = try(var.maintenance_window.start_minute, 0)
    }
  }

  dynamic "storage" {
    for_each = try(var.storage, {}) != {} ? [1] : []

    content {
      auto_grow_enabled = try(var.storage.auto_grow_enabled, true)
      iops              = try(var.storage.iops, 360)
      size_gb           = try(var.storage.size_gb, 20)
    }
  }
}

#--------------------------------------
# Generate sql server random admin password if not provided in the attribute administrator_login_password
#--------------------------------------
# resource "random_password" "sql_admin" {
#   count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

#   length           = 128
#   special          = true
#   upper            = true
#   numeric          = true
#   override_special = "$#%"
# }

#--------------------------------------
# Store the generated password into keyvault
#--------------------------------------
# resource "azurerm_key_vault_secret" "sql_admin_password" {
#   count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

#   name         = can(var.settings.keyvault_secret_name) ? var.settings.keyvault_secret_name : format("%s-password", var.name)
#   value        = random_password.sql_admin.0.result
#   key_vault_id = var.keyvault_id

#   lifecycle {
#     ignore_changes = [
#       value
#     ]
#   }
# }
