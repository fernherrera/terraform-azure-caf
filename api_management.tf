#---------------------------------
# Local declarations
#---------------------------------
locals {
  api_management_managed_identities = {
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
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  sku_name                                = try(each.value.sku_name, null)
  publisher_name                          = each.value.publisher_name
  publisher_email                         = each.value.publisher_email
  additional_location                     = try(each.value.additional_location, [])
  zones                                   = try(each.value.zones, null)
  client_certificate_enabled              = try(each.value.client_certificate_enabled, false)
  certificate_configuration               = try(each.value.certificate_configuration, [])
  gateway_disabled                        = try(each.value.gateway_disabled, false)
  min_api_version                         = try(each.value.min_api_version, null)
  enable_http2                            = try(each.value.enable_http2, false)
  notification_sender_email               = try(each.value.notification_sender_email, null)
  enable_sign_in                          = try(each.value.enable_sign_in, false)
  enable_sign_up                          = try(each.value.enable_sign_up, false)
  management_hostname_configuration       = try(each.value.management_hostname_configuration, [])
  scm_hostname_configuration              = try(each.value.scm_hostname_configuration, [])
  proxy_hostname_configuration            = try(each.value.proxy_hostname_configuration, [])
  portal_hostname_configuration           = try(each.value.portal_hostname_configuration, [])
  developer_portal_hostname_configuration = try(each.value.developer_portal_hostname_configuration, [])
  policy_configuration                    = try(each.value.policy_configuration, {})
  terms_of_service_configuration          = try(each.value.terms_of_service_configuration, [])
  security_configuration                  = try(each.value.security_configuration, {})
  identity                                = try(local.api_management_managed_identities[each.key], {})
  named_values                            = try(each.value.named_values, [])
  products                                = try(each.value.products, [])
  create_product_group_and_relationships  = try(each.value.create_product_group_and_relationships, false)
  redis_cache_configuration               = try(each.value.redis_cache_configuration, {})
  virtual_network_type                    = try(each.value.virtual_network_type, null)
  virtual_network_configuration           = try(each.value.virtual_network_configuration, null)
  subnets                                 = try(module.virtual_subnets, null)
}


#----------------------------------------------------------
# APIM Products
#----------------------------------------------------------
module "api_management_product" {
  source   = "./modules/api_management/product"
  for_each = local.apim.api_management_product

  api_management_name   = can(each.value.api_management_name) ? each.value.api_management_name : try(local.combined_objects.api_management[each.value.api_management_key].name, null)
  resource_group_name   = can(each.value.resource_group_name) ? each.value.resource_group_name : try(local.combined_objects.api_management[each.value.api_management_key].resource_group_name, null)
  product_id            = each.value.product_id
  display_name          = each.value.display_name
  approval_required     = each.value.approval_required
  subscription_required = each.value.subscription_required
  subscriptions_limit   = each.value.subscriptions_limit
  published             = each.value.published
}


#----------------------------------------------------------
# APIM Subscriptions
#----------------------------------------------------------
module "api_management_subscription" {
  source   = "./modules/api_management/subscription"
  for_each = local.apim.api_management_subscription

  api_management_name = can(each.value.api_management_name) ? each.value.api_management_name : try(local.combined_objects.api_management[each.value.api_management_key].name, null)
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(local.combined_objects.api_management[each.value.api_management_key].resource_group_name, null)
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
