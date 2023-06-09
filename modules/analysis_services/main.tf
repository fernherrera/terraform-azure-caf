#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = try(var.tags, {})
}

#---------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#--------------------------------------
# Analysis Services Server
#--------------------------------------
resource "azurerm_analysis_services_server" "server" {
  name                      = var.name
  location                  = local.location
  resource_group_name       = local.resource_group_name
  tags                      = local.tags
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