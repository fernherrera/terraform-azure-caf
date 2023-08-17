#----------------------------------------------------------
# App Service Plan 
#----------------------------------------------------------
resource "azurerm_service_plan" "asp" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

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
