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

#----------------------------------------------------------
# Public DNS Zone Resource Creation
#----------------------------------------------------------
resource "azurerm_dns_zone" "dns_zone" {
  name                = var.name
  resource_group_name = local.resource_group_name
  tags                = local.tags

  soa_record {
    email         = lookup(var.soa_record, "email", null)
    host_name     = lookup(var.soa_record, "host_name", null)
    expire_time   = lookup(var.soa_record, "expire_time", null)
    minimum_ttl   = lookup(var.soa_record, "minimum_ttl", null)
    refresh_time  = lookup(var.soa_record, "refresh_time", null)
    retry_time    = lookup(var.soa_record, "retry_time", null)
    serial_number = lookup(var.soa_record, "serial_number", null)
    ttl           = lookup(var.soa_record, "ttl", null)
    tags          = lookup(var.soa_record, "tags", null)
  }
}