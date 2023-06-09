data "azurerm_key_vault" "keyvault" {
  name                = "imxvwanidkv01"
  resource_group_name = "imx-infra-core-rg-mgmt-eus-01"
}

data "azurerm_key_vault_secret" "vwansecret" {
  name         = "vwanid-secret-01"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_vpn_site" "VPN_site" {
  for_each            = var.vwan_vpn_site_variables
  name                = each.value["name"]
  resource_group_name = each.value["resource_group_name"]
  location            = each.value["location"]
  virtual_wan_id      = data.azurerm_key_vault_secret.vwansecret.value
  address_cidrs       = each.value["address_cidrs"]
  device_vendor       = each.value["device_vendor"]

  link {
    name          = each.value["link_name"]
    ip_address    = each.value["link_ip_address"]
    provider_name = each.value["provider_name"]
    speed_in_mbps = each.value["speed_in_mbps"]
  }

  lifecycle {
    ignore_changes = [
      virtual_wan_id
    ]
  }
}
