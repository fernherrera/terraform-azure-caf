#----------------------------------------------------------
# Local configuration - Default (required). 
#----------------------------------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#----------------------------------------------------------
# Virtual WAN
#----------------------------------------------------------
resource "azurerm_virtual_wan" "vwan" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  type                              = try(var.type, "Standard")
  disable_vpn_encryption            = try(var.disable_vpn_encryption, false)
  allow_branch_to_branch_traffic    = try(var.allow_branch_to_branch_traffic, true)
  office365_local_breakout_category = try(var.office365_local_breakout_category, "None")
}

#----------------------------------------------------------
# Virtual Hubs
#----------------------------------------------------------
module "virtual_hubs" {
  source   = "./virtual_hub"
  for_each = try(var.virtual_hubs, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.local
  tags                = try(each.value.tags, {})

  virtual_wan_id = try(each.value.virtual_wan_id, null)
  sku            = try(each.value.sku, null)
  address_prefix = try(each.value.address_prefix, null)
  route          = try(each.value.route, {})
}