#----------------------------------------------------------
# Local declarations
#----------------------------------------------------------
locals {
  default_app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = try(var.application_insight.instrumentation_key, null),
    APPLICATIONINSIGHTS_CONNECTION_STRING = try(var.application_insight.connection_string, null),
    WEBSITE_LOAD_CERTIFICATES             = "*"
  }

  app_settings = merge(local.default_app_settings, var.app_settings)
}

#----------------------------------------------------------
# Linux Function App  
#----------------------------------------------------------
resource "azurerm_linux_function_app" "function_app" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  service_plan_id                    = var.service_plan_id
  app_settings                       = local.app_settings
  builtin_logging_enabled            = var.builtin_logging_enabled
  client_certificate_enabled         = var.client_certificate_enabled
  client_certificate_mode            = var.client_certificate_mode
  client_certificate_exclusion_paths = var.client_certificate_exclusion_paths
  daily_memory_time_quota            = var.daily_memory_time_quota
  enabled                            = var.enabled
  content_share_force_disabled       = var.content_share_force_disabled
  functions_extension_version        = var.functions_extension_version
  https_only                         = var.https_only
  storage_account_access_key         = var.storage_account_access_key
  storage_account_name               = var.storage_account_name
  storage_uses_managed_identity      = var.storage_account_access_key == null ? var.storage_uses_managed_identity : null
  storage_key_vault_secret_id        = var.storage_account_name == null ? var.storage_key_vault_secret_id : null
  virtual_network_subnet_id          = var.virtual_network_subnet_id

  dynamic "auth_settings" {
    for_each = try(var.auth_settings, null) != null ? [1] : []

    content {
      enabled                        = try(var.auth_settings.enabled, false)
      additional_login_parameters    = try(var.auth_settings.additional_login_parameters, null)
      allowed_external_redirect_urls = try(var.auth_settings.allowed_external_redirect_urls, null)
      default_provider               = try(var.auth_settings.default_provider, null)
      issuer                         = try(var.auth_settings.issuer, null)
      runtime_version                = try(var.auth_settings.runtime_version, null)
      token_refresh_extension_hours  = try(var.auth_settings.token_refresh_extension_hours, null)
      token_store_enabled            = try(var.auth_settings.token_store_enabled, null)
      unauthenticated_client_action  = try(var.auth_settings.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = try(var.auth_settings.active_directory, null) != null ? [1] : []

        content {
          client_id         = var.auth_settings.active_directory.client_id
          client_secret     = try(var.auth_settings.active_directory.client_secret, null)
          allowed_audiences = try(var.auth_settings.active_directory.allowed_audiences, null)
        }
      }

      dynamic "facebook" {
        for_each = try(var.auth_settings.facebook, null) != null ? [1] : []

        content {
          app_id       = var.auth_settings.facebook.app_id
          app_secret   = var.auth_settings.facebook.app_secret
          oauth_scopes = try(var.auth_settings.facebook.oauth_scopes, null)
        }
      }

      dynamic "google" {
        for_each = try(var.auth_settings.google, null) != null ? [1] : []

        content {
          client_id     = var.auth_settings.google.client_id
          client_secret = var.auth_settings.google.client_secret
          oauth_scopes  = try(var.auth_settings.google.oauth_scopes, null)
        }
      }

      dynamic "microsoft" {
        for_each = try(var.auth_settings.microsoft, null) != null ? [1] : []

        content {
          client_id     = var.auth_settings.microsoft.client_id
          client_secret = var.auth_settings.microsoft.client_secret
          oauth_scopes  = try(var.auth_settings.microsoft.oauth_scopes, null)
        }
      }

      dynamic "twitter" {
        for_each = try(var.auth_settings.twitter, null) != null ? [1] : []

        content {
          consumer_key    = var.auth_settings.twitter.consumer_key
          consumer_secret = var.auth_settings.twitter.consumer_secret
        }
      }

      dynamic "github" {
        for_each = try(var.auth_settings.github, null) != null ? [1] : []

        content {
          client_id                  = var.auth_settings.github.client_id
          client_secret              = var.auth_settings.github.client_secret
          client_secret_setting_name = var.auth_settings.github.client_secret_setting_name
          oauth_scopes               = try(var.auth_settings.github.oauth_scopes, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = try(connection_string.value.name, null)
      type  = try(connection_string.value.type, null)
      value = try(connection_string.value.value, null)
    }
  }

  dynamic "backup" {
    for_each = try(var.backup, null) != null ? [1] : []

    content {
      name                = var.backup.name
      enabled             = var.backup.enabled
      storage_account_url = try(var.backup.storage_account_url, var.backup.backup_sas_url, null)

      dynamic "schedule" {
        for_each = try(var.backup.schedule, null) != null ? [1] : []

        content {
          frequency_interval       = var.backup.schedule.frequency_interval
          frequency_unit           = try(var.backup.schedule.frequency_unit, null)
          keep_at_least_one_backup = try(var.backup.schedule.keep_at_least_one_backup, null)
          retention_period_days    = try(var.backup.schedule.retention_period_days, null)
          start_time               = try(var.backup.schedule.start_time, null)
        }
      }
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [1] : []

    content {
      type         = var.identity.value.type
      identity_ids = concat(var.identity.value.managed_identities, [])
    }
  }

  dynamic "site_config" {
    for_each = try(var.site_config, null) != null ? [1] : []

    content {
      always_on                              = try(var.site_config.always_on, false)
      api_definition_url                     = try(var.site_config.api_definition_url, null)
      api_management_api_id                  = try(var.site_config.api_management_api_id, null)
      app_command_line                       = try(var.site_config.app_command_line, null)
      app_scale_limit                        = try(var.site_config.app_scale_limit, null)
      application_insights_connection_string = try(var.site_config.application_insights_connection_string, null)
      application_insights_key               = try(var.site_config.application_insights_key, null)
      default_documents                      = [try(var.site_config.default_documents, false)]
      elastic_instance_minimum               = try(var.site_config.elastic_instance_minimum, null)
      ftps_state                             = try(var.site_config.ftps_state, null)
      health_check_path                      = try(var.site_config.health_check_path, null)
      health_check_eviction_time_in_min      = try(var.site_config.health_check_eviction_time_in_min, null)
      http2_enabled                          = try(var.site_config.http2_enabled, null)
      load_balancing_mode                    = try(var.site_config.load_balancing_mode, null)
      managed_pipeline_mode                  = try(var.site_config.managed_pipeline_mode, null)
      minimum_tls_version                    = try(var.site_config.minimum_tls_version, null)
      pre_warmed_instance_count              = try(var.site_config.pre_warmed_instance_count, null)
      remote_debugging_enabled               = try(var.site_config.remote_debugging_enabled, null)
      remote_debugging_version               = try(var.site_config.remote_debugging_version, null)
      runtime_scale_monitoring_enabled       = try(var.site_config.runtime_scale_monitoring_enabled, null)
      scm_minimum_tls_version                = try(var.site_config.scm_minimum_tls_version, null)
      scm_use_main_ip_restriction            = try(var.site_config.scm_use_main_ip_restriction, null)
      use_32_bit_worker                      = try(var.site_config.use_32_bit_worker, null)
      vnet_route_all_enabled                 = try(var.site_config.vnet_route_all_enabled, null)
      websockets_enabled                     = try(var.site_config.websockets_enabled, null)
      worker_count                           = try(var.site_config.worker_count, null)

      dynamic "application_stack" {
        for_each = try(var.site_config.application_stack, null) != null ? [1] : []

        content {

          dynamic "docker" {
            for_each = try(var.site_config.application_stack.docker, {})

            content {
              image_name        = docker.image_name
              image_tag         = docker.image_tag
              registry_url      = docker.registry_url
              registry_username = try(docker.registry_username, null)
              registry_password = try(docker.registry_password, null)
            }
          }

          dotnet_version              = try(var.site_config.application_stack.dotnet_version, null)
          use_dotnet_isolated_runtime = try(var.site_config.application_stack.use_dotnet_isolated_runtime, null)
          java_version                = try(var.site_config.application_stack.java_version, null)
          node_version                = try(var.site_config.application_stack.node_version, null)
          python_version              = try(var.site_config.application_stack.python_version, null)
          powershell_core_version     = try(var.site_config.application_stack.powershell_core_version, null)
          use_custom_runtime          = try(var.site_config.application_stack.use_custom_runtime, null)
        }
      }

      dynamic "app_service_logs" {
        for_each = try(var.site_config.app_service_logs, null) != null ? [1] : []

        content {
          disk_quota_mb         = try(var.app_service_logs.disk_quota_mb, false)
          retention_period_days = try(var.app_service_logs.retention_period_days, false)
        }
      }

      dynamic "cors" {
        for_each = try(var.site_config.cors, null) != null ? [1] : []

        content {
          allowed_origins     = try(var.site_config.cors.allowed_origins, null)
          support_credentials = try(var.site_config.cors.support_credentials, null)
        }
      }

      dynamic "ip_restriction" {
        for_each = try(var.site_config.ip_restriction, [])

        content {
          action                    = try(var.site_config.ip_restriction.action, null)
          ip_address                = try(var.site_config.ip_restriction.ip_address, null)
          name                      = try(var.site_config.ip_restriction.name, null)
          priority                  = try(var.site_config.ip_restriction.priority, null)
          service_tag               = try(var.site_config.ip_restriction.service_tag, null)
          virtual_network_subnet_id = try(var.site_config.ip_restriction.virtual_network_subnet_id, null)

          dynamic "headers" {
            for_each = try(var.site_config.ip_restriction.headers, [])

            content {
              x_azure_fdid      = try(var.site_config.ip_restriction.headers.x_azure_fdid, null)
              x_fd_health_probe = try(var.site_config.ip_restriction.headers.x_fd_health_prob, null)
              x_forwarded_for   = try(var.site_config.ip_restriction.headers.x_forwarded_for, null)
              x_forwarded_host  = try(var.site_config.ip_restriction.headers.x_forwarded_host, null)
            }
          }
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = try(var.site_config.scm_ip_restriction, [])

        content {
          action                    = try(var.site_config.scm_ip_restriction.action, null)
          ip_address                = try(var.site_config.scm_ip_restriction.ip_address, null)
          name                      = try(var.site_config.scm_ip_restriction.name, null)
          priority                  = try(var.site_config.scm_ip_restriction.priority, null)
          service_tag               = try(var.site_config.scm_ip_restriction.service_tag, null)
          virtual_network_subnet_id = try(var.site_config.scm_ip_restriction.virtual_network_subnet_id, null)

          dynamic "headers" {
            for_each = try(var.site_config.scm_ip_restriction.headers, [])

            content {
              x_azure_fdid      = try(var.site_config.scm_ip_restriction.headers.x_azure_fdid, null)
              x_fd_health_probe = try(var.site_config.scm_ip_restriction.headers.x_fd_health_prob, null)
              x_forwarded_for   = try(var.site_config.scm_ip_restriction.headers.x_forwarded_for, null)
              x_forwarded_host  = try(var.site_config.scm_ip_restriction.headers.x_forwarded_host, null)
            }
          }
        }
      }
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.sticky_settings, null) != null ? [1] : []

    content {
      app_setting_names       = try(var.sticky_settings.app_setting_names, false)
      connection_string_names = try(var.sticky_settings.connection_string_names, false)
    }
  }

  dynamic "storage_account" {
    for_each = try(var.storage_account, {})

    content {
      access_key   = try(var.storage_account.access_key, null)
      account_name = try(var.storage_account.account_name, null)
      name         = try(var.storage_account.name, null)
      share_name   = try(var.storage_account.share_name, null)
      type         = try(var.storage_account.type, null)
      mount_path   = try(var.storage_account.mount_path, null)
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
      app_settings.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING,
      app_settings.WEBSITE_CONTENTSHARE
    ]
  }
}