#-------------------------------
# Local Declarations
#-------------------------------
locals {
  id       = element(coalescelist(data.azurerm_api_management.apim_e.*.id, azurerm_api_management.apim.*.id, [""]), 0)
  name     = element(coalescelist(data.azurerm_api_management.apim_e.*.name, azurerm_api_management.apim.*.name, [""]), 0)
  location = element(coalescelist(data.azurerm_api_management.apim_e.*.location, azurerm_api_management.apim.*.location, [""]), 0)

  additional_location  = element(coalescelist(data.azurerm_api_management.apim_e.*.additional_location, azurerm_api_management.apim.*.additional_location, [""]), 0)
  gateway_url          = element(coalescelist(data.azurerm_api_management.apim_e.*.gateway_url, azurerm_api_management.apim.*.gateway_url, [""]), 0)
  gateway_regional_url = element(coalescelist(data.azurerm_api_management.apim_e.*.gateway_regional_url, azurerm_api_management.apim.*.gateway_regional_url, [""]), 0)
  management_api_url   = element(coalescelist(data.azurerm_api_management.apim_e.*.management_api_url, azurerm_api_management.apim.*.management_api_url, [""]), 0)
  portal_url           = element(coalescelist(data.azurerm_api_management.apim_e.*.portal_url, azurerm_api_management.apim.*.portal_url, [""]), 0)
  public_ip_addresses  = element(coalescelist(data.azurerm_api_management.apim_e.*.public_ip_addresses, azurerm_api_management.apim.*.public_ip_addresses, [""]), 0)
  private_ip_addresses = element(coalescelist(data.azurerm_api_management.apim_e.*.private_ip_addresses, azurerm_api_management.apim.*.private_ip_addresses, [""]), 0)
  scm_url              = element(coalescelist(data.azurerm_api_management.apim_e.*.scm_url, azurerm_api_management.apim.*.scm_url, [""]), 0)
  identity             = element(coalescelist(data.azurerm_api_management.apim_e.*.identity, azurerm_api_management.apim.*.identity, [""]), 0)
}

#--------------------------------------
# API Management
#--------------------------------------
data "azurerm_api_management" "apim_e" {
  count = var.existing == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management" "apim" {
  count = var.existing == false ? 1 : 0

  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  publisher_name             = var.publisher_name
  publisher_email            = var.publisher_email
  sku_name                   = var.sku_name
  zones                      = var.zones
  min_api_version            = var.min_api_version
  gateway_disabled           = var.gateway_disabled
  client_certificate_enabled = var.client_certificate_enabled
  notification_sender_email  = var.notification_sender_email
  virtual_network_type       = var.virtual_network_type
  tags                       = var.tags

  sign_in {
    enabled = var.enable_sign_in
  }

  sign_up {
    enabled = var.enable_sign_up

    dynamic "terms_of_service" {
      for_each = length(var.terms_of_service_configuration) == 0 ? [{ k = "1" }] : var.terms_of_service_configuration

      content {
        consent_required = lookup(terms_of_service.value, "consent_required", false)
        enabled          = lookup(terms_of_service.value, "enabled", false)
        text             = lookup(terms_of_service.value, "text", "")
      }
    }
  }

  dynamic "additional_location" {
    for_each = var.additional_location

    content {
      location = lookup(additional_location.value, "location", null)
      capacity = lookup(additional_location.value, "capacity", null)
      zones    = lookup(additional_location.value, "zones", [1, 2, 3])

      dynamic "virtual_network_configuration" {
        for_each = lookup(additional_location.value, "subnet_id", null) == null ? [] : [1]

        content {
          subnet_id = additional_location.value.subnet_id
        }
      }
    }
  }

  dynamic "certificate" {
    for_each = var.certificate_configuration

    content {
      encoded_certificate  = lookup(certificate.value, "encoded_certificate")
      certificate_password = lookup(certificate.value, "certificate_password")
      store_name           = lookup(certificate.value, "store_name")
    }
  }

  dynamic "identity" {
    for_each = can(var.identity) ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = concat(identity.value.managed_identities, [])
    }
  }

  dynamic "hostname_configuration" {
    for_each = length(concat(
      var.management_hostname_configuration,
      var.portal_hostname_configuration,
      var.developer_portal_hostname_configuration,
      var.proxy_hostname_configuration,
    )) == 0 ? [] : ["fake"]

    content {
      dynamic "management" {
        for_each = var.management_hostname_configuration

        content {
          host_name                    = lookup(management.value, "host_name")
          key_vault_id                 = lookup(management.value, "key_vault_id", null)
          certificate                  = lookup(management.value, "certificate", null)
          certificate_password         = lookup(management.value, "certificate_password", null)
          negotiate_client_certificate = lookup(management.value, "negotiate_client_certificate", false)
        }
      }

      dynamic "portal" {
        for_each = var.portal_hostname_configuration

        content {
          host_name                    = lookup(portal.value, "host_name")
          key_vault_id                 = lookup(portal.value, "key_vault_id", null)
          certificate                  = lookup(portal.value, "certificate", null)
          certificate_password         = lookup(portal.value, "certificate_password", null)
          negotiate_client_certificate = lookup(portal.value, "negotiate_client_certificate", false)
        }
      }

      dynamic "developer_portal" {
        for_each = var.developer_portal_hostname_configuration

        content {
          host_name                    = lookup(developer_portal.value, "host_name")
          key_vault_id                 = lookup(developer_portal.value, "key_vault_id", null)
          certificate                  = lookup(developer_portal.value, "certificate", null)
          certificate_password         = lookup(developer_portal.value, "certificate_password", null)
          negotiate_client_certificate = lookup(developer_portal.value, "negotiate_client_certificate", false)
        }
      }

      dynamic "proxy" {
        for_each = var.proxy_hostname_configuration

        content {
          host_name                    = lookup(proxy.value, "host_name")
          default_ssl_binding          = lookup(proxy.value, "default_ssl_binding", false)
          key_vault_id                 = lookup(proxy.value, "key_vault_id", null)
          certificate                  = lookup(proxy.value, "certificate", null)
          certificate_password         = lookup(proxy.value, "certificate_password", null)
          negotiate_client_certificate = lookup(proxy.value, "negotiate_client_certificate", false)
        }
      }

      dynamic "scm" {
        for_each = var.scm_hostname_configuration

        content {
          host_name                    = lookup(scm.value, "host_name")
          key_vault_id                 = lookup(scm.value, "key_vault_id", null)
          certificate                  = lookup(scm.value, "certificate", null)
          certificate_password         = lookup(scm.value, "certificate_password", null)
          negotiate_client_certificate = lookup(scm.value, "negotiate_client_certificate", false)
        }
      }

    }
  }

  dynamic "policy" {
    for_each = var.policy_configuration

    content {
      xml_content = lookup(policy.value, "xml_content", null)
      xml_link    = lookup(policy.value, "xml_link", null)
    }
  }

  protocols {
    enable_http2 = var.enable_http2
  }

  dynamic "security" {
    for_each = var.security_configuration

    content {
      enable_backend_ssl30  = lookup(security.value, "enable_backend_ssl30", false)
      enable_backend_tls10  = lookup(security.value, "enable_backend_tls10", false)
      enable_backend_tls11  = lookup(security.value, "enable_backend_tls11", false)
      enable_frontend_ssl30 = lookup(security.value, "enable_frontend_ssl30", false)
      enable_frontend_tls10 = lookup(security.value, "enable_frontend_tls10", false)
      enable_frontend_tls11 = lookup(security.value, "enable_frontend_tls11", false)

      tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = lookup(security.value, "tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled", false)
      tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = lookup(security.value, "tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled", false)
      tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = lookup(security.value, "tls_ecdheRsa_with_aes128_cbc_sha_ciphers_enabled", lookup(security.value, "tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled", false))
      tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = lookup(security.value, "tls_ecdheRsa_with_aes256_cbc_sha_ciphers_enabled", lookup(security.value, "tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled", false))
      tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = lookup(security.value, "tls_rsa_with_aes128_cbc_sha256_ciphers_enabled", false)
      tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = lookup(security.value, "tls_rsa_with_aes128_cbc_sha_ciphers_enabled", false)
      tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = lookup(security.value, "tls_rsa_with_aes128_gcm_sha256_ciphers_enabled", false)
      tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = lookup(security.value, "tls_rsa_with_aes256_cbc_sha256_ciphers_enabled", false)
      tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = lookup(security.value, "tls_rsa_with_aes256_cbc_sha_ciphers_enabled", false)

      triple_des_ciphers_enabled = lookup(security.value, "triple_des_ciphers_enabled ", false)
    }
  }

  dynamic "virtual_network_configuration" {
    for_each = try(var.virtual_network_configuration, null) != null ? [var.virtual_network_configuration] : []

    content {
      subnet_id = can(virtual_network_configuration.value.subnet_id) ? virtual_network_configuration.value.subnet_id : try(var.subnets[virtual_network_configuration.value.vnet_key].subnets[virtual_network_configuration.value.subnet_key].id, null)
    }
  }
}

#--------------------------------------
# APIM Named Value
#--------------------------------------
resource "azurerm_api_management_named_value" "named_values" {
  for_each = { for named_value in var.named_values : named_value["name"] => named_value }

  api_management_name = local.name
  display_name        = lookup(each.value, "display_name", lookup(each.value, "name"))
  name                = lookup(each.value, "name")
  resource_group_name = var.resource_group_name
  value               = lookup(each.value, "value")
  secret              = lookup(each.value, "secret", false)
}

#--------------------------------------
# APIM Product
#--------------------------------------
resource "azurerm_api_management_product" "product" {
  for_each = toset(var.products)

  product_id            = each.key
  resource_group_name   = var.resource_group_name
  api_management_name   = local.name
  display_name          = each.key
  subscription_required = true
  approval_required     = true
  published             = true
  subscriptions_limit   = 1
}

resource "azurerm_api_management_group" "group" {
  for_each = var.create_product_group_and_relationships ? toset(var.products) : []

  name                = each.key
  resource_group_name = var.resource_group_name
  api_management_name = local.name
  display_name        = each.key
}

resource "azurerm_api_management_product_group" "product_group" {
  for_each = var.create_product_group_and_relationships ? toset(var.products) : []

  product_id          = each.key
  resource_group_name = var.resource_group_name
  api_management_name = local.name
  group_name          = each.key
}

#--------------------------------------
# APIM Redis Cache
#--------------------------------------
module "redis_cache" {
  source   = "./redis_cache"
  for_each = var.redis_cache_configuration

  name                                       = each.value.name
  resource_group_name                        = var.resource_group_name
  location                                   = var.location
  tags                                       = var.tags
  capacity                                   = try(each.value.capacity, 1)
  sku_name                                   = try(each.value.sku_name, "Basic")
  shard_count                                = try(each.value.shard_count, 1)
  enable_non_ssl_port                        = try(each.value.enable_non_ssl_port, false)
  private_static_ip_address                  = try(each.value.private_static_ip_address, null)
  subnet_id                                  = try(each.value.subnet_id, null)
  zones                                      = try(each.value.zones, null)
  redis_version                              = try(each.value.redis_version, 6)
  redis_configuration                        = try(each.value.redis_configuration, {})
  storage_account_name                       = try(each.value.storage_account_name, null)
  data_persistence_enabled                   = try(each.value.data_persistence_enabled, false)
  data_persistence_backup_frequency          = try(each.value.data_persistence_backup_frequency, 60)
  data_persistence_backup_max_snapshot_count = try(each.value.data_persistence_backup_max_snapshot_count, 1)
  firewall_rules                             = try(each.value.firewall_rules, null)
  enable_private_endpoint                    = try(each.value.enable_private_endpoint, false)
  virtual_network_name                       = try(each.value.virtual_network_name, "")
  existing_private_dns_zone                  = try(each.value.existing_private_dns_zone, null)
  private_subnet_address_prefix              = try(each.value.private_subnet_address_prefix, null)
}

resource "azurerm_api_management_redis_cache" "example" {
  for_each = module.redis_cache

  name              = each.value.redis_cache_instance_name
  api_management_id = local.id
  connection_string = each.value.redis_cache_primary_connection_string
  description       = "Redis cache instance"
  redis_cache_id    = each.value.redis_cache_instance_id
  # cache_location    = "East Us"
}
