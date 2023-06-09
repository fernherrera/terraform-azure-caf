module "storage_accounts" {
  source   = "./modules/storage/storage_account"
  for_each = local.storage.storage_accounts

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  custom_domain              = try(each.value.custom_domain, {})
  enable_system_msi          = try(each.value.enable_system_msi, {})
  identity                   = try(each.value.identity, {})
  static_website             = try(each.value.static_website, {})
  network                    = try(each.value.network, {})
  azure_files_authentication = try(each.value.azure_files_authentication, {})
  routing                    = try(each.value.routing, {})
  containers                 = try(each.value.containers, {})
  data_lake_filesystems      = try(each.value.data_lake_filesystems, {})
  management_policies        = try(each.value.management_policies, {})
  backup                     = try(each.value.backup, null)
  recovery_vaults            = try(each.value.recovery_vaults, {})
  managed_identities         = try(each.value.managed_identities, {})
  resource_groups            = module.resource_groups
  virtual_subnets            = module.virtual_subnets
  private_endpoints          = try(each.value.private_endpoints, {})
}

# output "storage_accounts" {
#   value     = module.storage_accounts
#   sensitive = true
# }