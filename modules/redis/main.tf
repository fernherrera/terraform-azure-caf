#------------------------------------------------------------
# Local configuration - Default (required). 
#------------------------------------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )

  redis_family_map = {
    Basic    = "C",
    Standard = "C",
    Premium  = "P"
  }

  data_persistence_enabled = var.sku_name == "Premium" ? var.data_persistence_enabled : false
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

data "azurerm_log_analytics_workspace" "logws" {
  count               = var.log_analytics_workspace_name != null ? 1 : 0
  name                = var.log_analytics_workspace_name
  resource_group_name = local.resource_group_name
}

#---------------------------------------------------------------
# Storage Account to keep logs and backups - Default is "false"
#---------------------------------------------------------------
resource "random_string" "str" {
  count   = local.data_persistence_enabled ? 1 : 0
  length  = 6
  special = false
  upper   = false
  keepers = {
    name = var.storage_account_name
  }
}

resource "azurerm_storage_account" "storeacc" {
  #  for_each                  = var.redis_configuration != {} ? { for rdb_backup_enabled, v in var.redis_configuration : rdb_backup_enabled => v if v == true } : null
  count                     = local.data_persistence_enabled ? 1 : 0
  name                      = var.storage_account_name == null ? "rediscachebkpstore${random_string.str.0.result}" : substr(var.storage_account_name, 0, 24)
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                      = local.tags
}

#------------------------------------------------------------
# Redis Cache Instance configuration - Default (required). 
#------------------------------------------------------------
resource "azurerm_redis_cache" "main" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

  redis_version                 = var.redis_version
  capacity                      = var.capacity
  family                        = lookup(local.redis_family_map, var.sku_name)
  sku_name                      = var.sku_name
  shard_count                   = var.sku_name == "Premium" ? var.shard_count : 0
  minimum_tls_version           = var.minimum_tls_version
  enable_non_ssl_port           = var.enable_non_ssl_port
  private_static_ip_address     = var.private_static_ip_address
  public_network_access_enabled = var.public_network_access_enabled
  replicas_per_master           = var.sku_name == "Premium" ? var.replicas_per_master : null
  subnet_id                     = var.sku_name == "Premium" ? var.subnet_id : null
  zones                         = var.zones

  redis_configuration {
    #  aof_backup_enabled              = var.enable_aof_backup
    #  aof_storage_connection_string_0 = var.enable_aof_backup == true ? azurerm_storage_account.storeacc.0.primary_blob_connection_string : null
    #  aof_storage_connection_string_1 = var.enable_aof_backup == true ? azurerm_storage_account.storeacc.0.secondary_blob_connection_string : null
    enable_authentication           = lookup(var.redis_configuration, "enable_authentication", true)
    maxfragmentationmemory_reserved = var.sku_name == "Premium" || var.sku_name == "Standard" ? lookup(var.redis_configuration, "maxfragmentationmemory_reserved") : null
    maxmemory_delta                 = var.sku_name == "Premium" || var.sku_name == "Standard" ? lookup(var.redis_configuration, "maxmemory_delta") : null
    maxmemory_policy                = lookup(var.redis_configuration, "maxmemory_policy")
    maxmemory_reserved              = var.sku_name == "Premium" || var.sku_name == "Standard" ? lookup(var.redis_configuration, "maxmemory_reserved") : null
    notify_keyspace_events          = lookup(var.redis_configuration, "notify_keyspace_events")
    rdb_backup_enabled              = local.data_persistence_enabled == true ? true : false
    rdb_backup_frequency            = local.data_persistence_enabled == true ? var.data_persistence_backup_frequency : null
    rdb_backup_max_snapshot_count   = local.data_persistence_enabled == true ? var.data_persistence_backup_max_snapshot_count : null
    rdb_storage_connection_string   = local.data_persistence_enabled == true ? azurerm_storage_account.storeacc.0.primary_blob_connection_string : null
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week    = var.patch_schedule.day_of_week
      start_hour_utc = var.patch_schedule.start_hour_utc
    }
  }

  lifecycle {
    # A bug in the Redis API where the original storage connection string isn't being returneds
    ignore_changes = [redis_configuration.0.rdb_storage_connection_string]
  }
}

#----------------------------------------------------------------------
# Adding Firewall rules for Redis Cache Instance - Default is "false"
#----------------------------------------------------------------------
resource "azurerm_redis_firewall_rule" "name" {
  for_each = var.firewall_rules != null ? { for k, v in var.firewall_rules : k => v if v != null } : {}

  name                = format("%s", each.key)
  redis_cache_name    = element([for n in azurerm_redis_cache.main : n.name], 0)
  resource_group_name = local.resource_group_name
  start_ip            = each.value["start_ip"]
  end_ip              = each.value["end_ip"]
}


#---------------------------------------------------------
# Private Link for Redis Server - Default is "false" 
#---------------------------------------------------------
data "azurerm_virtual_network" "vnet01" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = var.virtual_network_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet" "snet-ep" {
  count                                          = var.enable_private_endpoint ? 1 : 0
  name                                           = "snet-endpoint-shared-${local.location}"
  resource_group_name                            = local.resource_group_name
  virtual_network_name                           = data.azurerm_virtual_network.vnet01.0.name
  address_prefixes                               = var.private_subnet_address_prefix
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_endpoint" "pep1" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = format("%s-private-endpoint", element([for n in azurerm_redis_cache.main : n.name], 0))
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = azurerm_subnet.snet-ep.0.id
  tags                = merge({ "Name" = format("%s-private-endpoint", element([for n in azurerm_redis_cache.main : n.name], 0)) }, local.tags, )

  private_service_connection {
    name                           = "rediscache-privatelink"
    is_manual_connection           = false
    private_connection_resource_id = element([for i in azurerm_redis_cache.main : i.id], 0)
    subresource_names              = ["redisCache"]
  }
}

data "azurerm_private_endpoint_connection" "private-ip1" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_private_endpoint.pep1.0.name
  resource_group_name = local.resource_group_name
  depends_on          = [azurerm_redis_cache.main]
}

resource "azurerm_private_dns_zone" "dnszone1" {
  count               = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vent-link1" {
  count                 = var.existing_private_dns_zone == null && var.enable_private_endpoint ? 1 : 0
  name                  = "vnet-private-zone-link"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnszone1.0.name
  virtual_network_id    = data.azurerm_virtual_network.vnet01.0.id
  tags                  = local.tags
}

resource "azurerm_private_dns_a_record" "arecord1" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = element([for n in azurerm_redis_cache.main : n.name], 0)
  zone_name           = var.existing_private_dns_zone == null ? azurerm_private_dns_zone.dnszone1.0.name : var.existing_private_dns_zone
  resource_group_name = local.resource_group_name
  ttl                 = 300
  records             = [data.azurerm_private_endpoint_connection.private-ip1.0.private_service_connection.0.private_ip_address]
}

#------------------------------------------------------------------
# azurerm monitoring diagnostics  - Default is "false" 
#------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "extaudit" {
  count                      = var.log_analytics_workspace_name != null ? 1 : 0
  name                       = lower("extaudit-${element([for n in azurerm_redis_cache.main : n.name], 0)}-diag")
  target_resource_id         = element([for i in azurerm_redis_cache.main : i.id], 0)
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logws.0.id
  storage_account_id         = local.data_persistence_enabled ? azurerm_storage_account.storeacc.0.id : null

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [metric]
  }
}