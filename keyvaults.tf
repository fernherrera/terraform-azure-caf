module "keyvaults" {
  source   = "./modules/security/keyvault"
  for_each = local.security.keyvaults

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  client_config       = local.client_config
  tenant_id           = local.client_config.tenant_id
  settings            = each.value.settings
  vnets               = try(each.value.vnets, {})
  diagnostic_settings = try(each.value.diagnostic_settings, {})
  resource_groups     = try(each.value.resource_groups, {})
  private_dns         = try(each.value.private_dns, {})
  azuread_groups      = try(each.value.azuread_groups, {})
  managed_identities  = try(each.value.managed_identities, {})
}

# Keyvault access policies
module "keyvault_access_policies" {
  source   = "./modules/security/keyvault_access_policies"
  for_each = local.security.keyvault_access_policies

  keyvault_key    = each.value.keyvault_key
  keyvaults       = local.combined_objects.keyvaults
  access_policies = each.value.access_policies
  client_config   = local.client_config
  azuread_groups  = local.combined_objects.azuread_groups
  resources = {
    azuread_service_principals        = local.combined_objects.azuread_service_principals
    diagnostic_storage_accounts       = local.combined_objects.diagnostic_storage_accounts
    managed_identities                = local.combined_objects.managed_identities
    mssql_managed_instances           = local.combined_objects.mssql_managed_instances
    mssql_managed_instances_secondary = local.combined_objects.mssql_managed_instances_secondary
    storage_accounts                  = local.combined_objects.storage_accounts
  }
}

# Need to separate keyvault policies from azure AD apps to get the keyvault with the default policies.
# Reason - Azure AD apps passwords are stored into keyvault secrets and combining would create a circular reference
module "keyvault_access_policies_azuread_apps" {
  source   = "./modules/security/keyvault_access_policies"
  for_each = local.security.keyvault_access_policies_azuread_apps

  keyvault_key    = each.key
  keyvaults       = local.combined_objects.keyvaults
  access_policies = each.value
  client_config   = local.client_config
  azuread_apps    = local.combined_objects.azuread_apps
}

output "keyvaults" {
  value = module.keyvaults
}