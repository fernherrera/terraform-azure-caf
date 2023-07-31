#----------------------------------------------------------
# Locals declarations for Azure private DNS Zones
#----------------------------------------------------------
locals {
  az_private_dns_zones = {
    # Azure Migrate
    privatelink-prod-migration-windowsazure-com = { name = "privatelink.prod.migration.windowsazure.com" }

    # Azure Key Vault
    privatelink-vaultcore-azure-net = { name = "privatelink.vaultcore.azure.net" }

    # Azure SQL Database
    privatelink-database-windows-net = { name = "privatelink.database.windows.net" }

    # Azure Database for MySQL
    privatelink-mysql-database-azure-com = { name = "privatelink.mysql.database.azure.com" }

    # Azure Data Factory
    privatelink-datafactory-azure-net = { name = "privatelink.datafactory.azure.net" }
    privatelink-adf-azure-com         = { name = "privatelink.adf.azure.com" }

    # Azure Synapse Analytics
    privatelink-sql-azuresynapse-net = { name = "privatelink.sql.azuresynapse.net" }
    privatelink-dev-azuresynapse-net = { name = "privatelink.dev.azuresynapse.net" }

    # Azure PowerBI
    privatelink-analysis-windows-net          = { name = "privatelink.analysis.windows.net" }
    privatelink-pbidedicated-windows-net      = { name = "privatelink.pbidedicated.windows.net" }
    privatelink-tip1-powerquery-microsoft-com = { name = "privatelink.tip1.powerquery.microsoft.com" }

    # Storage account
    privatelink-blob-core-windows-net  = { name = "privatelink.blob.core.windows.net" }
    privatelink-table-core-windows-net = { name = "privatelink.table.core.windows.net" }
    privatelink-queue-core-windows-net = { name = "privatelink.queue.core.windows.net" }
    privatelink-file-core-windows-net  = { name = "privatelink.file.core.windows.net" }
    privatelink-web-core-windows-net   = { name = "privatelink.web.core.windows.net" }
    privatelink-dfs-core-windows-net   = { name = "privatelink.dfs.core.windows.net" }

    # Azure Web Apps
    privatelink-azurewebsites-net     = { name = "privatelink.azurewebsites.net" }
    scm-privatelink-azurewebsites-net = { name = "scm.privatelink.azurewebsites.net" }

    # Azure API Management
    privatelink-azure-api-net           = { name = "privatelink.azure-api.net" }
    privatelink-developer-azure-api-net = { name = "privatelink.developer.azure-api.net" }
  }

  private_dns_zones = {
    for k, v in local.az_private_dns_zones : k => merge(var.networking.private_dns_defaults, local.az_private_dns_zones[k])
  }

  private_dns_zones_combined = merge(try(var.networking.private_dns_zones, {}), try(local.private_dns_zones, {}))
}


#----------------------------------------------------------
# Private DNS Zones
#----------------------------------------------------------
module "private_dns" {
  source   = "./modules/networking/private_dns"
  for_each = local.private_dns_zones_combined

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)
  records             = try(each.value.records, {})
  vnet_links          = try(each.value.vnet_links, {})
  vnets               = try(module.virtual_networks, {})
}