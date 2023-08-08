#---------------------------------
# Local declarations
#---------------------------------
locals {
  storage_accounts_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.storage.storage_accounts : {
          sa_key = sa_key
          type   = try(sa.identity.type, "SystemAssigned")
          managed_identities = concat(
            try(sa.identity.managed_identity_ids, []),
            flatten([
              for managed_identity_key in try(sa.identity.managed_identity_keys, []) : [
                module.managed_identities[managed_identity_key].id
              ]
            ])
          )
        } if try(sa.identity, null) != null
      ]
    ) : format("%s", managed_identity.sa_key) => managed_identity
  }

  storage_accounts_private_endpoints = {
    for private_endpoint in
    flatten(
      [
        for sa_key, sa in local.storage.storage_accounts : [
          for pe_key, pe in try(sa.private_endpoints, {}) : {
            sa_key              = sa_key
            pe_key              = pe_key
            id                  = module.storage_accounts[sa_key].id
            resource_group_name = module.resource_groups[pe.resource_group_key].name
            location            = module.resource_groups[pe.resource_group_key].location
            tags                = module.storage_accounts[sa_key].tags
            name                = try(pe.name, "")
            subnet_id           = try(pe.vnet_key, null) == null ? null : try(module.virtual_subnets[pe.vnet_key].subnets[pe.subnet_key].id)
            private_service_connection = merge(try(pe.private_service_connection, {}), {
              private_connection_resource_id = module.storage_accounts[sa_key].id
            })
          }
        ]
      ]
    ) : format("%s-%s", private_endpoint.sa_key, private_endpoint.pe_key) => private_endpoint
  }
}

#--------------------------------------
# Storage Accounts
#--------------------------------------
module "storage_accounts" {
  source   = "./modules/storage/storage_account"
  for_each = local.storage.storage_accounts

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  azure_files_authentication = try(each.value.azure_files_authentication, {})
  backup                     = try(each.value.backup, null)
  containers                 = try(each.value.containers, {})
  custom_domain              = try(each.value.custom_domain, {})
  data_lake_filesystems      = try(each.value.data_lake_filesystems, {})
  enable_system_msi          = try(each.value.enable_system_msi, {})
  file_shares                = try(each.value.file_shares, {})
  identity                   = try(local.storage_accounts_managed_identities[each.key], null)
  management_policies        = try(each.value.management_policies, {})
  network                    = try(each.value.network, {})
  private_endpoints          = try(each.value.private_endpoints, {})
  queues                     = try(each.value.queues, {})
  routing                    = try(each.value.routing, {})
  recovery_vaults            = try(each.value.recovery_vaults, {})
  static_website             = try(each.value.static_website, {})
  tables                     = try(each.value.tables, {})
}

#--------------------------------------
# Storage Accounts Private Endpoints
#--------------------------------------
#
# Storage Account is one of the three diagnostics destination objects and for that reason requires the
# private endpoint to be done at the root module to prevent circular references
#
module "storage_accounts_private_endpoints" {
  source   = "./modules/networking/private_endpoint"
  for_each = local.storage_accounts_private_endpoints

  depends_on = [module.storage_accounts]

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tags                          = each.value.tags
  subnet_id                     = each.value.subnet_id
  private_service_connection    = each.value.private_service_connection
  private_dns_zone_group        = try(each.value.private_dns_zone_group, {})
  custom_network_interface_name = try(each.value.custom_network_interface_name, null)
  ip_configuration              = try(each.value.ip_configuration, [])
}