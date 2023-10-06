data "azurerm_storage_account" "backup_storage_account" {
  count = can(var.backup) ? 1 : 0

  name                = local.backup_storage_account.name
  resource_group_name = local.backup_storage_account.resource_group_name
}

data "azurerm_storage_account_blob_container_sas" "backup" {
  count = can(var.backup.container_key) ? 1 : 0

  connection_string = data.azurerm_storage_account.backup_storage_account.0.primary_connection_string
  container_name    = local.backup_storage_account.containers[var.backup.container_key].name
  https_only        = true

  start  = time_rotating.sas[0].id
  expiry = timeadd(time_rotating.sas[0].id, format("%sh", var.backup.sas_policy.expire_in_days * 24))

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

data "azurerm_storage_account_blob_container_sas" "logs" {
  count = can(var.logs.container_key) ? 1 : 0

  connection_string = data.azurerm_storage_account.backup_storage_account.0.primary_connection_string
  container_name    = local.logs_storage_account.containers[var.logs.container_key].name
  https_only        = true

  start  = time_rotating.logs_sas[0].id
  expiry = timeadd(time_rotating.logs_sas[0].id, format("%sh", var.logs.sas_policy.expire_in_days * 24))

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

data "azurerm_storage_account_blob_container_sas" "http_logs" {
  count = can(var.logs.http_logs.container_key) ? 1 : 0

  connection_string = data.azurerm_storage_account.backup_storage_account.0.primary_connection_string
  container_name    = local.http_logs_storage_account.containers[var.logs.http_logs.container_key].name
  https_only        = true

  start  = time_rotating.http_logs_sas[0].id
  expiry = timeadd(time_rotating.http_logs_sas[0].id, format("%sh", var.logs.http_logs.sas_policy.expire_in_days * 24))

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = true
    list   = true
  }
}

resource "time_rotating" "sas" {
  count = can(var.backup.sas_policy) ? 1 : 0

  rotation_minutes = try(var.backup.sas_policy.rotation.mins, null)
  rotation_days    = try(var.backup.sas_policy.rotation.days, null)
  rotation_months  = try(var.backup.sas_policy.rotation.months, null)
  rotation_years   = try(var.backup.sas_policy.rotation.years, null)
}

resource "time_rotating" "logs_sas" {
  count = can(var.logs.sas_policy) ? 1 : 0

  rotation_minutes = try(var.logs.sas_policy.rotation.mins, null)
  rotation_days    = try(var.logs.sas_policy.rotation.days, null)
  rotation_months  = try(var.logs.sas_policy.rotation.months, null)
  rotation_years   = try(var.logs.sas_policy.rotation.years, null)
}

resource "time_rotating" "http_logs_sas" {
  count = can(var.logs.http_logs.sas_policy) ? 1 : 0

  rotation_minutes = try(var.logs.http_logs.sas_policy.rotation.mins, null)
  rotation_days    = try(var.logs.http_logs.sas_policy.rotation.days, null)
  rotation_months  = try(var.logs.http_logs.sas_policy.rotation.months, null)
  rotation_years   = try(var.logs.http_logs.sas_policy.rotation.years, null)
}