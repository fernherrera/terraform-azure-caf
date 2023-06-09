#
# Managed identities from remote state, local and set by resource ids
#

locals {
  /*
  managed_local_identities = flatten([
    for managed_identity_key in try(var.identity.managed_identity_keys, []) : [
      var.combined_objects.managed_identities[var.client_config.landingzone_key][managed_identity_key].id
    ]
  ])

  managed_remote_identities = flatten([
    for keyvault_key, value in try(var.identity.remote, []) : [
      for managed_identity_key in value.managed_identity_keys : [
        var.combined_objects.managed_identities[keyvault_key][managed_identity_key].id
      ]
    ]
  ])
*/

  identity_type       = try(var.identity.type, "SystemAssigned")
  provided_identities = try(var.identity.managed_identity_ids, [])
  managed_identities  = concat(local.provided_identities /*, local.managed_local_identities, local.managed_remote_identities*/)
}