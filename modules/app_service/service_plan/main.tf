#-------------------------------
# Local Declarations
#-------------------------------

locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#---------------------------------------------------------
# App Service Plan Creation 
#----------------------------------------------------------
resource "azurerm_service_plan" "asp" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  os_type                      = var.os_type
  sku_name                     = var.sku_name
  app_service_environment_id   = try(var.app_service_environment_id, null)
  maximum_elastic_worker_count = try(var.maximum_elastic_worker_count, null)
  worker_count                 = try(var.worker_count, null)
  per_site_scaling_enabled     = try(var.per_site_scaling_enabled, false)
  zone_balancing_enabled       = try(var.zone_balancing_enabled, false)

  timeouts {
    create = "5h"
    update = "5h"
  }

  lifecycle {
    # TEMP until native tf provider for ASE ready to avoid force replacement of asp on every ase changes
    ignore_changes = [app_service_environment_id]
  }
}
