# Tested with :  AzureRM version 2.61.0
# Ref : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_container_storage_account


locals {
  recovery_vault = try(var.backup, null) == null ? null : try(var.recovery_vaults[var.backup.vault_key], {})
}

resource "azurerm_backup_container_storage_account" "container" {
  for_each = try(var.backup, null) == null ? toset([]) : toset(["enabled"])

  storage_account_id  = local.id
  resource_group_name = local.recovery_vault.resource_group_name
  recovery_vault_name = local.recovery_vault.name
}
