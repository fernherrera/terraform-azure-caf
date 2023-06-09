#----------------------------------------------------------
# Express Route Gateway
#----------------------------------------------------------
resource "azurerm_express_route_gateway" "er_gateway" {
  for_each = try(var.express_route_gateways, {})

  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  virtual_hub_id      = azurerm_virtual_hub.vwan_hub.id
  scale_units         = each.value.scale_units

  timeouts {
    create = "60m"
    delete = "120m"
  }

  # Add a lifecycle until bug fixed https://github.com/hashicorp/terraform-provider-azurerm/issues/13368
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}