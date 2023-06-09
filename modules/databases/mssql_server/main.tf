#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = local.tags
}

#--------------------------------------
# MSSQL Server
#--------------------------------------
resource "azurerm_mssql_server" "mssql" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  version                       = try(var.settings.version, "12.0")
  administrator_login           = try(var.settings.azuread_administrator.azuread_authentication_only, false) == true ? null : var.settings.administrator_login
  administrator_login_password  = try(var.settings.azuread_administrator.azuread_authentication_only, false) == true ? null : try(var.settings.administrator_login_password, azurerm_key_vault_secret.sql_admin_password.0.value)
  public_network_access_enabled = try(var.settings.public_network_access_enabled, true)
  connection_policy             = try(var.settings.connection_policy, null)
  minimum_tls_version           = try(var.settings.minimum_tls_version, null)

  dynamic "azuread_administrator" {
    for_each = can(var.settings.azuread_administrator) ? [var.settings.azuread_administrator] : []

    content {
      azuread_authentication_only = try(var.settings.azuread_administrator.azuread_authentication_only, false)
      login_username              = try(var.settings.azuread_administrator.login_username, try(var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].name, var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].name))
      object_id                   = try(var.settings.azuread_administrator.object_id, try(var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].id, var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].id))
      tenant_id                   = try(var.settings.azuread_administrator.tenant_id, try(var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].tenant_id, var.azuread_groups[var.settings.azuread_administrator.azuread_group_key].tenant_id))
    }
  }

  dynamic "identity" {
    for_each = can(var.settings.identity) ? [var.settings.identity] : []

    content {
      type = identity.value.type
    }
  }

  # This is a hack, to avoid terraform from always destorying and recreating SQL server and attached DBs.azuread_administrator {
  # TODO: Find out why it thinks location keeps changing.
  lifecycle {
    ignore_changes = [
      location
    ]
  }
}

#--------------------------------------
# SQL Server firewall rules
#--------------------------------------
resource "azurerm_mssql_firewall_rule" "firewall_rules" {
  for_each = try(var.settings.firewall_rules, {})

  name             = each.value.name
  server_id        = azurerm_mssql_server.mssql.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_virtual_network_rule" "network_rules" {
  for_each = try(var.settings.network_rules, {})

  name      = each.value.name
  server_id = azurerm_mssql_server.mssql.id
  subnet_id = can(each.value.subnet_id) ? each.value.subnet_id : var.virtual_subnets[each.value.vnet_key].subnets[each.value.subnet_key].id
}

#--------------------------------------
# Generate sql server random admin password if not provided in the attribute administrator_login_password
#--------------------------------------
resource "random_password" "sql_admin" {
  count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

  length           = 128
  special          = true
  upper            = true
  numeric          = true
  override_special = "$#%"
}

#--------------------------------------
# Store the generated password into keyvault
#--------------------------------------
resource "azurerm_key_vault_secret" "sql_admin_password" {
  count = try(var.settings.administrator_login_password, null) == null ? 1 : 0

  name         = can(var.settings.keyvault_secret_name) ? var.settings.keyvault_secret_name : format("%s-password", var.name)
  value        = random_password.sql_admin.0.result
  key_vault_id = var.keyvault_id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

#--------------------------------------
# Transparent data encryption
#--------------------------------------
resource "azurerm_mssql_server_transparent_data_encryption" "tde" {
  count = try(var.settings.transparent_data_encryption.enable, false) ? 1 : 0

  server_id        = azurerm_mssql_server.mssql.id
  key_vault_key_id = can(var.settings.transparent_data_encryption.encryption_key) ? var.remote_objects.keyvault_keys[var.settings.transparent_data_encryption.encryption_key.keyvault_key_key].id : null
}
