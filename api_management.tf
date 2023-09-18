#---------------------------------
# Local declarations
#---------------------------------
locals {
  apim_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.apim.api_management : {
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

  apim_virtual_network_configuration = {
    for vnet_config in
    flatten(
      [
        for apim_key, apim in local.apim.api_management : {
          apim_key  = apim_key
          subnet_id = can(apim.virtual_network_configuration.subnet_id) ? apim.virtual_network_configuration.subnet_id : try(module.virtual_subnets[apim.virtual_network_configuration.vnet_key].subnets[apim.virtual_network_configuration.subnet_key].id, null)
        } if try(apim.virtual_network_configuration, null) != null
      ]
    ) : format("%s", vnet_config.apim_key) => vnet_config
  }

  apim_custom_domains_gateway = try({
    for gateway in
    flatten(
      [
        for k, domain in local.apim.api_management.custom_domains.gateway : merge({
          key          = k
          key_vault_id = try(domain.key_vault_id, module.keyvaults[domain.key_vault_key].certificates[domain.key_vault_cert_key].versionless_secret_id, null)
          },
        domain)
      ]
    ) : gateway.key => gateway
  }, null)

  apim_custom_domains_developer_portal = try({
    for developer_portal in
    flatten(
      [
        for k, domain in local.apim.api_management.custom_domains.developer_portal : merge({
          key          = k
          key_vault_id = try(domain.key_vault_id, module.keyvaults[domain.key_vault_key].certificates[domain.key_vault_cert_key].versionless_secret_id, null)
          },
        domain)
      ]
    ) : developer_portal.key => developer_portal
  }, null)

  apim_custom_domains_management = try({
    for management in
    flatten(
      [
        for k, domain in local.apim.api_management.custom_domains.management : merge({
          key          = k
          key_vault_id = try(domain.key_vault_id, module.keyvaults[domain.key_vault_key].certificates[domain.key_vault_cert_key].versionless_secret_id, null)
          },
        domain)
      ]
    ) : management.key => management
  }, null)

  apim_custom_domains_portal = try({
    for portal in
    flatten(
      [
        for k, domain in local.apim.api_management.custom_domains.portal : merge({
          key          = k
          key_vault_id = try(domain.key_vault_id, module.keyvaults[domain.key_vault_key].certificates[domain.key_vault_cert_key].versionless_secret_id, null)
          },
        domain)
      ]
    ) : portal.key => portal
  }, null)

  apim_custom_domains_scm = try({
    for scm in
    flatten(
      [
        for k, domain in local.apim.api_management.custom_domains.scm : merge({
          key          = k
          key_vault_id = try(domain.key_vault_id, module.keyvaults[domain.key_vault_key].certificates[domain.key_vault_cert_key].versionless_secret_id, null)
          },
        domain)
      ]
    ) : scm.key => scm
  }, null)

  apim_custom_domains = merge(
    local.apim_custom_domains_gateway,
    local.apim_custom_domains_developer_portal,
    local.apim_custom_domains_management,
    local.apim_custom_domains_portal,
    local.apim_custom_domains_scm
  )
}

#----------------------------------------------------------
# API Management
#----------------------------------------------------------
module "api_management" {
  source   = "./modules/api_management"
  for_each = local.apim.api_management

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), local.global_settings.tags)
  sku_name            = each.value.sku_name
  publisher_name      = each.value.publisher_name
  publisher_email     = each.value.publisher_email

  additional_location           = try(each.value.additional_location, [])
  certificate_configuration     = try(each.value.certificate_configuration, [])
  client_certificate_enabled    = try(each.value.client_certificate_enabled, false)
  custom_domains                = try(local.apim_custom_domains, {})
  enable_http2                  = try(each.value.enable_http2, false)
  enable_sign_in                = try(each.value.enable_sign_in, false)
  enable_sign_up                = try(each.value.enable_sign_up, false)
  gateway_disabled              = try(each.value.gateway_disabled, false)
  identity                      = try(local.apim_managed_identities[each.key], null)
  min_api_version               = try(each.value.min_api_version, null)
  named_values                  = try(each.value.named_values, [])
  notification_sender_email     = try(each.value.notification_sender_email, null)
  policy_configuration          = try(each.value.policy_configuration, {})
  security                      = try(each.value.security, {})
  terms_of_service              = try(each.value.terms_of_service, [])
  redis_cache_configuration     = try(each.value.redis_cache_configuration, {})
  virtual_network_type          = try(each.value.virtual_network_type, null)
  virtual_network_configuration = try(local.apim_virtual_network_configuration, null)
  zones                         = try(each.value.zones, null)
}


#----------------------------------------------------------
# APIM Products
#----------------------------------------------------------
module "api_management_product" {
  source   = "./modules/api_management/product"
  for_each = local.apim.api_management_product

  api_management_name   = can(each.value.api_management_name) ? each.value.api_management_name : try(module.api_management[each.value.api_management_key].name, null)
  resource_group_name   = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.api_management[each.value.api_management_key].resource_group_name, null)
  approval_required     = each.value.approval_required
  display_name          = each.value.display_name
  product_id            = each.value.product_id
  published             = each.value.published
  subscription_required = each.value.subscription_required
  subscriptions_limit   = each.value.subscriptions_limit
}


#----------------------------------------------------------
# APIM Subscriptions
#----------------------------------------------------------
module "api_management_subscription" {
  source   = "./modules/api_management/subscription"
  for_each = local.apim.api_management_subscription

  api_management_name = can(each.value.api_management_name) ? each.value.api_management_name : try(module.api_management[each.value.api_management_key].name, null)
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.api_management[each.value.api_management_key].resource_group_name, null)
  display_name        = each.value.display_name
  product_id          = can(each.value.product_id) ? each.value.product_id : try(module.api_management_product[each.value.product_key].product_id, null)
  user_id             = try(each.value.user_id, null)
  api_id              = try(each.value.api_id, null)
  primary_key         = try(each.value.primary_key, null)
  secondary_key       = try(each.value.secondary_key, null)
  state               = try(each.value.state, null)
  subscription_id     = try(each.value.subscription_id, null)
  allow_tracing       = try(each.value.allow_tracing, null)
}
