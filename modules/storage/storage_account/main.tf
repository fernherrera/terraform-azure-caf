#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#---------------------------------------------------------
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
  tags     = merge({ "Name" = format("%s", var.resource_group_name) }, local.tags, )
}

#---------------------------------------------------------
# Storage Account Resource Creation
#----------------------------------------------------------
resource "azurerm_storage_account" "stg" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = merge({ "Name" = format("%s", var.name) }, local.tags, )

  access_tier                       = try(var.access_tier, "Hot")
  account_kind                      = try(var.account_kind, "StorageV2")
  account_replication_type          = try(var.account_replication_type, "LRS")
  account_tier                      = try(var.account_tier, "Standard")
  enable_https_traffic_only         = try(var.enable_https_traffic_only, true)
  infrastructure_encryption_enabled = try(var.infrastructure_encryption_enabled, null)
  is_hns_enabled                    = try(var.is_hns_enabled, false)
  large_file_share_enabled          = try(var.large_file_share_enabled, null)
  min_tls_version                   = try(var.min_tls_version, "TLS1_2")
  nfsv3_enabled                     = try(var.nfsv3_enabled, false)
  queue_encryption_key_type         = try(var.queue_encryption_key_type, null)
  table_encryption_key_type         = try(var.table_encryption_key_type, null)


  dynamic "custom_domain" {
    for_each = try(var.custom_domain, {})

    content {
      name          = var.custom_domain.name
      use_subdomain = try(var.custom_domain.use_subdomain, null)
    }
  }

  dynamic "identity" {
    for_each = try(var.enable_system_msi, {})

    content {
      type = "SystemAssigned"
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, {})

    content {
      type         = identity.value.type
      identity_ids = local.managed_identities
    }
  }

  dynamic "blob_properties" {
    for_each = try(var.blob_properties, {})

    content {
      versioning_enabled       = try(var.blob_properties.versioning_enabled, false)
      change_feed_enabled      = try(var.blob_properties.change_feed_enabled, false)
      default_service_version  = try(var.blob_properties.default_service_version, "2020-06-12")
      last_access_time_enabled = try(var.blob_properties.last_access_time_enabled, false)

      dynamic "cors_rule" {
        for_each = lookup(var.blob_properties, "cors_rule", false) == false ? [] : [1]

        content {
          allowed_headers    = var.blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = lookup(var.blob_properties, "delete_retention_policy", false) == false ? [] : [1]

        content {
          days = try(var.blob_properties.delete_retention_policy.delete_retention_policy, 7)
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = lookup(var.blob_properties, "container_delete_retention_policy", false) == false ? [] : [1]

        content {
          days = try(var.blob_properties.container_delete_retention_policy.container_delete_retention_policy, 7)
        }
      }
    }
  }

  dynamic "queue_properties" {
    for_each = try(var.queue_properties, {})

    content {
      dynamic "cors_rule" {
        for_each = lookup(var.queue_properties, "cors_rule", false) == false ? [] : [1]

        content {
          allowed_headers    = var.queue_properties.cors_rule.allowed_headers
          allowed_methods    = var.queue_properties.cors_rule.allowed_methods
          allowed_origins    = var.queue_properties.cors_rule.allowed_origins
          exposed_headers    = var.queue_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.queue_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = lookup(var.queue_properties, "logging", false) == false ? [] : [1]

        content {
          delete                = var.queue_properties.logging.delete
          read                  = var.queue_properties.logging.read
          write                 = var.queue_properties.logging.write
          version               = var.queue_properties.logging.version
          retention_policy_days = try(var.queue_properties.logging.retention_policy_days, 7)
        }
      }

      dynamic "minute_metrics" {
        for_each = lookup(var.queue_properties, "minute_metrics", false) == false ? [] : [1]

        content {
          enabled               = var.queue_properties.minute_metrics.enabled
          version               = var.queue_properties.minute_metrics.version
          include_apis          = try(var.queue_properties.minute_metrics.include_apis, null)
          retention_policy_days = try(var.queue_properties.minute_metrics.retention_policy_days, 7)
        }
      }

      dynamic "hour_metrics" {
        for_each = lookup(var.queue_properties, "hour_metrics", false) == false ? [] : [1]

        content {
          enabled               = var.queue_properties.hour_metrics.enabled
          version               = var.queue_properties.hour_metrics.version
          include_apis          = try(var.queue_properties.hour_metrics.include_apis, null)
          retention_policy_days = try(var.queue_properties.hour_metrics.retention_policy_days, 7)
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = try(var.static_website, {})

    content {
      index_document     = try(var.static_website.index_document, null)
      error_404_document = try(var.static_website.error_404_document, null)
    }
  }

  dynamic "network_rules" {
    for_each = try(var.network, {})

    content {
      bypass         = try(var.network.bypass, [])
      default_action = try(var.network.default_action, "Deny")
      ip_rules       = try(var.network.ip_rules, [])
      virtual_network_subnet_ids = try(var.network.subnets, null) == null ? null : [
        for key, value in var.network.subnets : value.remote_subnet_id
      ]
    }
  }

  dynamic "azure_files_authentication" {
    for_each = try(var.azure_files_authentication, {})

    content {
      directory_type = var.azure_files_authentication.directory_type

      dynamic "active_directory" {
        for_each = lookup(var.azure_files_authentication, "active_directory", false) == false ? [] : [1]

        content {
          storage_sid         = var.azure_files_authentication.active_directory.storage_sid
          domain_name         = var.azure_files_authentication.active_directory.domain_name
          domain_sid          = var.azure_files_authentication.active_directory.domain_sid
          domain_guid         = var.azure_files_authentication.active_directory.domain_guid
          forest_name         = var.azure_files_authentication.active_directory.forest_name
          netbios_domain_name = var.azure_files_authentication.active_directory.netbios_domain_name
        }
      }
    }
  }

  dynamic "routing" {
    for_each = try(var.routing, {})

    content {
      publish_internet_endpoints  = try(var.routing.publish_internet_endpoints, false)
      publish_microsoft_endpoints = try(var.routing.publish_microsoft_endpoints, false)
      choice                      = try(var.routing.choice, "MicrosoftRouting")
    }
  }

  lifecycle {
    ignore_changes = [
      location, resource_group_name
    ]
  }
}

module "queue" {
  source   = "./queue"
  for_each = try(var.queues, {})

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "table" {
  source   = "./table"
  for_each = try(var.tables, {})

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "container" {
  source   = "./container"
  for_each = try(var.containers, {})

  storage_account_name = azurerm_storage_account.stg.name
  settings             = each.value
}

module "data_lake_filesystem" {
  source   = "./data_lake_filesystem"
  for_each = try(var.data_lake_filesystems, {})

  storage_account_id = azurerm_storage_account.stg.id
  settings           = each.value
}

module "file_share" {
  source     = "./file_share"
  for_each   = try(var.file_shares, {})
  depends_on = [azurerm_backup_container_storage_account.container]

  storage_account_name = azurerm_storage_account.stg.name
  storage_account_id   = azurerm_storage_account.stg.id
  settings             = each.value
  recovery_vault       = local.recovery_vault
  resource_group_name  = local.resource_group_name
}

module "management_policy" {
  source   = "./management_policy"
  for_each = try(var.management_policies, {})

  storage_account_id = azurerm_storage_account.stg.id
  settings           = try(var.management_policies, {})
}
