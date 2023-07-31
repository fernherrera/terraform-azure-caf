#-------------------------------
# Local Declarations
#-------------------------------
locals {
  id        = element(coalescelist(data.azurerm_key_vault.keyvault_e.*.id, azurerm_key_vault.keyvault.*.id, [""]), 0)
  name      = element(coalescelist(data.azurerm_key_vault.keyvault_e.*.name, azurerm_key_vault.keyvault.*.name, [""]), 0)
  vault_uri = element(coalescelist(data.azurerm_key_vault.keyvault_e.*.vault_uri, azurerm_key_vault.keyvault.*.vault_uri, [""]), 0)
}

#----------------------------------------------------------
# Key Vault
#----------------------------------------------------------
data "azurerm_key_vault" "keyvault_e" {
  count = var.existing == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault" "keyvault" {
  count = var.existing == false ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  enabled_for_deployment          = try(var.enabled_for_deployment, false)
  enabled_for_disk_encryption     = try(var.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = try(var.enabled_for_template_deployment, false)
  enable_rbac_authorization       = try(var.enable_rbac_authorization, false)
  purge_protection_enabled        = try(var.purge_protection_enabled, false)
  public_network_access_enabled   = try(var.public_network_access_enabled, true)
  soft_delete_retention_days      = try(var.soft_delete_retention_days, 7)

  timeouts {
    delete = "60m"
  }

  dynamic "network_acls" {
    for_each = try(var.network_acls, null) == null ? [] : [1]

    content {
      bypass         = var.network_acls.bypass
      default_action = try(var.network_acls.default_action, "Deny")
      ip_rules       = try(var.network_acls.ip_rules, null)
      virtual_network_subnet_ids = try(var.network_acls.subnets, null) == null ? null : [
        for key, value in var.network_acls.subnets : can(value.subnet_id) ? value.subnet_id : var.vnets[value.vnet_key].subnets[value.subnet_key].id
      ]
    }
  }

  dynamic "contact" {
    for_each = try(var.contact, {})

    content {
      email = contact.value.email
      name  = try(contact.value.name, null)
      phone = try(contact.value.phone, null)
    }
  }

  lifecycle {
    ignore_changes = [
      resource_group_name, location
    ]
  }
}