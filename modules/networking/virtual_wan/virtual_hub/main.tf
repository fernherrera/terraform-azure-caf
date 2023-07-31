#----------------------------------------------------------
# Local configuration
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
# Virtual Hub
#----------------------------------------------------------
resource "azurerm_virtual_hub" "vwan_hub" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  virtual_wan_id = try(var.virtual_wan_id, null)
  sku            = try(var.sku, null)
  address_prefix = try(var.address_prefix, null)

  dynamic "route" {
    for_each = try(var.route, {})

    content {
      address_prefixes    = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }

  timeouts {
    create = "60m"
    delete = "180m"
  }
}

#----------------------------------------------------------
# Virtual Hub Connection
#----------------------------------------------------------
resource "azurerm_virtual_hub_connection" "con" {
  for_each = try(var.connections, {})

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.vwan_hub.id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = try(each.value.internet_security_enabled, null)
}


#----------------------------------------------------------
# Virtual Hub IP
#----------------------------------------------------------
# resource "azurerm_virtual_hub_ip" "hub_ip" {
#   for_each = try(var.virtual_hub_config.hub_ip, {})

#   name                         = azurecaf_name.hub_ip[each.key].result
#   virtual_hub_id               = azurerm_virtual_hub.vwan_hub.id
#   private_ip_address           = each.value.private_ip_address
#   private_ip_allocation_method = each.value.private_ip_allocation_method
#   public_ip_address_id         = try(each.value.private_ip_address_id, null) != null ? each.value.private_ip_address_id : (lookup(each.value.public_ip_address, "lz_key", null) == null ? var.public_ip_addresses[var.client_config.landingzone_key][each.value.public_ip_address.public_ip_address_key].id : var.public_ip_addresses[each.value.public_ip_address.lz_key][each.value.public_ip_address.public_ip_address_key].id)
#   subnet_id                    = try(each.value.subnet_id, null) != null ? each.value.subnet_id : (lookup(each.value.subnet, "lz_key", null) == null ? var.virtual_networks[var.client_config.landingzone_key][each.value.subnet.vnet_key].subnets[each.value.subnet.subnet_key].id : var.virtual_networks[each.value.subnet.lz_key][each.value.subnet.vnet_key].subnets[each.value.subnet.subnet_key].id)
# }

#----------------------------------------------------------
# Virtual Hub BGP Connection
#----------------------------------------------------------
# resource "azurerm_virtual_hub_bgp_connection" "bgp_con" {
#   depends_on = [azurerm_virtual_hub_ip.hub_ip]
#   for_each   = try(var.virtual_hub_config.bgp_connection, {})

#   name           = azurecaf_name.bgp_con[each.key].result
#   virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
#   peer_asn       = each.value.peer_asn
#   peer_ip        = each.value.peer_ip
# }