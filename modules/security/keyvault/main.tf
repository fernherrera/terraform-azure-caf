#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = local.tags
}

#----------------------------------------------------------
# Key Vault
#----------------------------------------------------------
resource "azurerm_key_vault" "keyvault" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

  tenant_id                       = var.tenant_id
  sku_name                        = try(var.settings.sku_name, "standard")
  enabled_for_deployment          = try(var.settings.enabled_for_deployment, false)
  enabled_for_disk_encryption     = try(var.settings.enabled_for_disk_encryption, false)
  enabled_for_template_deployment = try(var.settings.enabled_for_template_deployment, false)
  purge_protection_enabled        = try(var.settings.purge_protection_enabled, false)
  soft_delete_retention_days      = try(var.settings.soft_delete_retention_days, 7)
  enable_rbac_authorization       = try(var.settings.enable_rbac_authorization, false)

  timeouts {
    delete = "60m"
  }

  dynamic "network_acls" {
    for_each = lookup(var.settings, "network", null) == null ? [] : [1]

    content {
      bypass         = var.settings.network.bypass
      default_action = try(var.settings.network.default_action, "Deny")
      ip_rules       = try(var.settings.network.ip_rules, null)
      virtual_network_subnet_ids = try(var.settings.network.subnets, null) == null ? null : [
        for key, value in var.settings.network.subnets : can(value.subnet_id) ? value.subnet_id : var.vnets[value.vnet_key].subnets[value.subnet_key].id
      ]
    }
  }

  dynamic "contact" {
    for_each = lookup(var.settings, "contacts", {})

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