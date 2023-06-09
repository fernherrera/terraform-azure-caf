#---------------------------------
# Local declarations
#---------------------------------
locals {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = merge(try(var.tags, {}), )

  route_origin_keys = { for key, route in var.routes : key => route.cdn_frontdoor_origin_keys }
  route_origin_ids = {
    for rk, r in local.route_origin_keys : rk => flatten([
      for ok in r : [azurerm_cdn_frontdoor_origin.org[ok].id
      ]
    ])
  }

  route_domain_keys = { for key, route in var.routes : key => route.cdn_frontdoor_custom_domain_keys }
  route_domain_ids = {
    for rk, r in local.route_domain_keys : rk => flatten([
      for dk in r : [azurerm_cdn_frontdoor_custom_domain.domains[dk].id]
    ])
  }
}

#----------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#----------------------------------------------------------
# Key Vault Certificates (previously created)
#----------------------------------------------------------
data "azurerm_key_vault_certificate" "existing" {
  for_each = try(var.secrets, {})

  name         = each.value.key_vault_certificate_name
  key_vault_id = var.key_vaults[each.value.key_vault_key].id
}

#----------------------------------------------------------
# CDN Frontdoor profile
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                     = local.name
  resource_group_name      = local.resource_group_name
  sku_name                 = var.sku_name
  response_timeout_seconds = var.response_timeout_seconds
  tags                     = try(local.tags, {})
}

#----------------------------------------------------------
# CDN Frontdoor Endpoints
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_endpoint" "ep" {
  for_each = try(var.endpoints, {})

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  tags                     = merge(try(each.value.tags, {}), local.tags)
}

#----------------------------------------------------------
# CDN Frontdoor Origin Groups
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin_group" "orggrp" {
  for_each = try(var.origin_groups, {})

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = try(each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes, 10)
  session_affinity_enabled                                  = try(each.value.session_affinity_enabled, true)

  load_balancing {
    additional_latency_in_milliseconds = try(each.value.load_balancing.additional_latency_in_milliseconds, 50)
    sample_size                        = try(each.value.load_balancing.sample_size, 4)
    successful_samples_required        = try(each.value.load_balancing.successful_samples_required, 3)
  }

  dynamic "health_probe" {
    for_each = lookup(each.value, "health_probe", {}) != {} ? [1] : []

    content {
      protocol            = try(health_probe.protocol, "Https")
      interval_in_seconds = try(health_probe.interval_in_seconds, 30)
      request_type        = try(health_probe.request_type, "HEAD")
      path                = try(health_probe.path, "/")
    }
  }
}

#----------------------------------------------------------
# CDN Frontdoor Origins
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_origin" "org" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.orggrp]
  for_each   = try(var.origins, {})

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = try(each.value.cdn_frontdoor_origin_group_id, azurerm_cdn_frontdoor_origin_group.orggrp[each.value.cdn_frontdoor_origin_group_key].id)
  enabled                        = try(each.value.enabled, true)
  certificate_name_check_enabled = try(each.value.certificate_name_check_enabled, true) # Required for Private Link
  host_name                      = each.value.host_name
  http_port                      = try(each.value.http_port, 80)
  https_port                     = try(each.value.https_port, 443)
  origin_host_header             = try(each.value.origin_host_header, null)
  priority                       = try(each.value.priority, 1)
  weight                         = try(each.value.weight, 500)

  dynamic "private_link" {
    for_each = lookup(each.value, "private_link", {}) != {} ? [1] : []

    content {
      request_message        = try(private_link.request_message, "Request access for CDN Frontdoor Private Link Origin")
      target_type            = try(private_link.target_type, "sites")
      location               = try(private_link.location, null)
      private_link_target_id = try(private_link.private_link_target_id, null)
    }
  }
}

#----------------------------------------------------------
# CDN Frontdoor Secrets
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_secret" "secrets" {
  for_each = try(var.secrets, {})

  name                     = try(each.value.name, format("%s-%s-latest", var.key_vaults[each.value.key_vault_key].name, each.value.key_vault_certificate_name))
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  secret {
    customer_certificate {
      key_vault_certificate_id = try(each.value.key_vault_certificate_id, data.azurerm_key_vault_certificate.existing[each.key].versionless_id)
    }
  }

  # This is a hack, have to figure out why this keeps triggering a destroy.
  lifecycle {
    ignore_changes = [
      secret[0].customer_certificate[0].key_vault_certificate_id
    ]
  }
}

#----------------------------------------------------------
# CDN Frontdoor Custom Domains
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_custom_domain" "domains" {
  for_each = try(var.custom_domains, {})

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  dns_zone_id              = try(each.value.dns_zone_id, null)
  host_name                = each.value.host_name

  tls {
    certificate_type        = try(each.value.tls.certificate_type, "ManagedCertificate")
    minimum_tls_version     = try(each.value.tls.minimum_tls_version, "TLS12")
    cdn_frontdoor_secret_id = try(each.value.tls.cdn_frontdoor_secret_id, azurerm_cdn_frontdoor_secret.secrets[each.value.tls.cdn_frontdoor_secret_key].id, null)
  }
}

#----------------------------------------------------------
# CDN Frontdoor Routes
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_route" "rt" {
  for_each = try(var.routes, {})

  name                          = each.value.name
  cdn_frontdoor_endpoint_id     = try(each.value.cdn_frontdoor_endpoint_id, azurerm_cdn_frontdoor_endpoint.ep[each.value.cdn_frontdoor_endpoint_key].id)
  cdn_frontdoor_origin_group_id = try(each.value.cdn_frontdoor_origin_group_id, azurerm_cdn_frontdoor_origin_group.orggrp[each.value.cdn_frontdoor_origin_group_key].id)
  cdn_frontdoor_origin_ids      = flatten([local.route_origin_ids[each.key]])
  cdn_frontdoor_rule_set_ids    = []
  enabled                       = try(each.value.enabled, true)
  forwarding_protocol           = try(each.value.forwarding_protocol, "HttpsOnly")
  https_redirect_enabled        = try(each.value.https_redirect_enabled, true)
  patterns_to_match             = try(each.value.patterns_to_match, ["/*"])
  supported_protocols           = try(each.value.supported_protocols, ["Http", "Https"])

  cdn_frontdoor_custom_domain_ids = flatten([local.route_domain_ids[each.key]])
  link_to_default_domain          = try(each.value.link_to_default_domain, false)

  dynamic "cache" {
    for_each = lookup(each.value, "cache", {}) != {} ? [1] : []

    content {
      query_string_caching_behavior = try(cache.query_string_caching_behavior, "IgnoreQueryString")
      query_strings                 = try(cache.query_strings, [])
      compression_enabled           = try(cache.compression_enabled, false)
      content_types_to_compress     = try(cache.content_types_to_compress, ["text/html", "text/javascript", "text/xml"])
    }
  }
}

#----------------------------------------------------------
# CDN Frontdoor WAF Policies
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {
  for_each = try(var.waf_policies, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
  sku_name            = azurerm_cdn_frontdoor_profile.fd.sku_name
  enabled             = try(each.value.enabled, true)
  mode                = try(each.value.mode, "Detection")
  redirect_url        = try(each.value.redirect_url, null)
  tags                = merge(try(each.value.tags, {}), local.tags)

  custom_block_response_status_code = try(each.value.custom_block_response_status_code, null)
  custom_block_response_body        = try(each.value.custom_block_response_body, null)

  dynamic "custom_rule" {
    for_each = try(each.value.custom_rule, {})

    content {
      name                           = format("%s", custom_rule.value.name)
      action                         = custom_rule.value.action
      enabled                        = true
      priority                       = custom_rule.value.priority
      type                           = custom_rule.value.type
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_threshold

      dynamic "match_condition" {
        for_each = try(custom_rule.value.match_condition, {})

        content {
          match_variable     = match_condition.value.match_variable
          match_values       = match_condition.value.match_values
          operator           = match_condition.value.operator
          selector           = match_condition.value.selector
          negation_condition = match_condition.value.negation_condition
          transforms         = match_condition.value.transforms
        }
      }
    }
  }

  dynamic "managed_rule" {
    for_each = try(each.value.managed_rule, {})

    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
      action  = managed_rule.value.action

      dynamic "exclusion" {
        for_each = managed_rule.value.exclusion

        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }

      dynamic "override" {
        for_each = managed_rule.value.override

        content {
          rule_group_name = override.value.rule_group_name

          dynamic "exclusion" {
            for_each = override.value.exclusion

            content {
              match_variable = exclusion.value.match_variable
              operator       = exclusion.value.operator
              selector       = exclusion.value.selector
            }
          }

          dynamic "rule" {
            for_each = override.value.rule

            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = lookup(rule.value, "enabled", false)
              dynamic "exclusion" {
                for_each = rule.value.exclusion

                content {
                  match_variable = exclusion.value.match_variable
                  operator       = exclusion.value.operator
                  selector       = exclusion.value.selector
                }
              }
            }
          }
        }
      }
    }
  }
}
#----------------------------------------------------------
# CDN Frontdoor Security Policies
#----------------------------------------------------------
resource "azurerm_cdn_frontdoor_security_policy" "security" {
  depends_on = [azurerm_cdn_frontdoor_firewall_policy.waf]

  for_each = try(var.security_policies, {})

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = can(each.value.security_policies.cdn_frontdoor_firewall_policy_id) ? each.value.security_policies.cdn_frontdoor_firewall_policy_id : azurerm_cdn_frontdoor_firewall_policy.waf[each.value.waf_policy_key].id

      association {

        dynamic "domain" {
          for_each = toset(try(each.value.domain_keys, []))

          content {
            cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.domains[domain.key].id
          }
        }

        patterns_to_match = try(each.value.patterns_to_match, ["/*"])
      }
    }
  }
}