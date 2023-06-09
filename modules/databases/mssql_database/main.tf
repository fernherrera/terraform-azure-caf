#---------------------------------
# Local declarations
#---------------------------------
locals {
  tags        = merge(try(var.tags, {}), )
  server_name = "${var.server_name}${var.cloud.sqlServerHostname}"

  db_permissions = {
    for group_key, group in try(var.settings.db_permissions, {}) : group_key => {
      db_roles = group.db_roles
      db_usernames = flatten([
        for lz_key, value in group.managed_identities : [
          for managed_identity_key in value.managed_identity_keys : [var.managed_identities[lz_key][managed_identity_key].name]
        ]
      ])
    }
  }
}

#--------------------------------------
# threat detection policy
#--------------------------------------
data "azurerm_storage_account" "mssqldb_tdp" {
  count = try(var.settings.threat_detection_policy.storage_account.key, null) == null ? 0 : 1

  name                = var.storage_accounts[var.settings.threat_detection_policy.storage_account.key].name
  resource_group_name = var.storage_accounts[var.settings.threat_detection_policy.storage_account.key].resource_group_name
}

#--------------------------------------
# MSSQL Server database
#--------------------------------------
resource "azurerm_mssql_database" "mssqldb" {
  name      = var.name
  tags      = local.tags
  server_id = var.server_id

  auto_pause_delay_in_minutes = try(var.settings.auto_pause_delay_in_minutes, null)
  collation                   = try(var.settings.collation, null)
  create_mode                 = try(var.settings.create_mode, null)
  creation_source_database_id = try(var.settings.creation_source_database_id, null)
  elastic_pool_id             = try(var.elastic_pool_id, null)
  geo_backup_enabled          = try(var.settings.geo_backup_enabled, null)
  license_type                = try(var.settings.license_type, null)
  max_size_gb                 = try(var.settings.max_size_gb, null)
  min_capacity                = try(var.settings.min_capacity, null)
  read_replica_count          = try(var.settings.read_replica_count, null)
  read_scale                  = try(var.settings.read_scale, null)
  recover_database_id         = try(var.settings.recover_database_id, null)
  restore_dropped_database_id = try(var.settings.restore_dropped_database_id, null)
  restore_point_in_time       = try(var.settings.restore_point_in_time, null)
  sample_name                 = try(var.settings.sample_name, null)
  sku_name                    = try(var.settings.sku_name, null)
  storage_account_type        = try(var.settings.storage_account_type, null)
  zone_redundant              = try(var.settings.zone_redundant, null)

  dynamic "threat_detection_policy" {
    for_each = lookup(var.settings, "threat_detection_policy", {}) == {} ? [] : [1]

    content {
      state                      = var.settings.threat_detection_policy.state
      disabled_alerts            = try(var.settings.threat_detection_policy.disabled_alerts, null)
      email_account_admins       = try(var.settings.threat_detection_policy.email_account_admins, null)
      email_addresses            = try(var.settings.threat_detection_policy.email_addresses, null)
      retention_days             = try(var.settings.threat_detection_policy.retention_days, null)
      storage_endpoint           = try(data.azurerm_storage_account.mssqldb_tdp.0.primary_blob_endpoint, null)
      storage_account_access_key = try(data.azurerm_storage_account.mssqldb_tdp.0.primary_access_key, null)
      # use_server_default         = try(var.settings.threat_detection_policy.use_server_default, null)
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = lookup(var.settings, "short_term_retention_policy", {}) == {} ? [] : [1]

    content {
      retention_days = try(var.settings.short_term_retention_policy.retention_days, null)
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = lookup(var.settings, "long_term_retention_policy", {}) == {} ? [] : [1]

    content {
      weekly_retention  = try(var.settings.long_term_retention_policy.weekly_retention, null)
      monthly_retention = try(var.settings.long_term_retention_policy.monthly_retention, null)
      yearly_retention  = try(var.settings.long_term_retention_policy.yearly_retention, null)
      week_of_year      = try(var.settings.long_term_retention_policy.week_of_year, null)
    }
  }
}
