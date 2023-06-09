
data "azurerm_key_vault" "keyvault" {
  name                = "imxvwanidkv01"
  resource_group_name = "imx-infra-core-rg-mgmt-eus-01"
}

data "azurerm_key_vault_secret" "vwansecret" {
  name         = "vwanid-secret-01"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

resource "azurerm_virtual_hub" "vwan_hub" {
  for_each            = var.vwan_hub_variables
  name                = each.value["name"]
  location            = each.value["location"]
  resource_group_name = each.value["resource_group_name"]
  virtual_wan_id      = data.azurerm_key_vault_secret.vwansecret.value
  address_prefix      = each.value["address_prefixes"]
  lifecycle {
    ignore_changes = [
      virtual_wan_id
    ]
  }
}
