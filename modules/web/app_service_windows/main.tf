#-------------------------------
# Local Declarations
#-------------------------------
locals {
  app_settings = merge(try(var.app_settings, {}), var.application_insight == null ? {} :
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY"             = var.application_insight.instrumentation_key,
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.application_insight.connection_string,
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3",
      "WEBSITE_LOAD_CERTIFICATES"                  = "*"
    }
  )
}

#---------------------------------------------------------
# Windows Web App Service 
#---------------------------------------------------------
resource "azurerm_windows_web_app" "web_app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  app_settings                       = local.app_settings
  client_affinity_enabled            = try(var.client_affinity_enabled, null)
  client_certificate_enabled         = try(var.client_certificate_enabled, null)
  client_certificate_mode            = try(var.client_certificate_mode, null)
  client_certificate_exclusion_paths = try(var.client_certificate_exclusion_paths, null)
  enabled                            = try(var.enabled, null)
  https_only                         = try(var.https_only, null)
  key_vault_reference_identity_id    = try(var.key_vault_reference_identity_id, null)
  service_plan_id                    = var.service_plan_id
  virtual_network_subnet_id          = try(var.virtual_network_subnet_id, null)
  zip_deploy_file                    = try(var.zip_deploy_file, null)

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

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = try(connection_string.value.name, null)
      type  = try(connection_string.value.type, null)
      value = try(connection_string.value.value, null)
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [1] : []

    content {
      type         = var.identity.value.type
      identity_ids = concat(var.identity.value.managed_identities, [])
    }
  }

  dynamic "logs" {
    for_each = try(var.logs, null) != null ? [1] : []

    content {
      detailed_error_messages = try(var.logs.detailed_error_messages, false)
      failed_request_tracing  = try(var.logs.failed_request_tracing, false)

      dynamic "application_logs" {
        for_each = try(var.logs.application_logs, null) != null ? [1] : []

        content {
          file_system_level = try(var.logs.application_logs.file_system_level, false)

          dynamic "azure_blob_storage" {
            for_each = try(var.logs.application_logs.azure_blob_storage, null) != null ? [1] : []

            content {
              level             = try(var.logs.http_logs.application_logs.azure_blob_storage.level, false)
              retention_in_days = try(var.logs.http_logs.application_logs.azure_blob_storage.retention_in_days, false)
              sas_url           = try(var.logs.http_logs.application_logs.azure_blob_storage.sas_url, false)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = try(var.logs.http_logs, null) != null ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = try(var.logs.http_logs.azure_blob_storage, null) != null ? [1] : []

            content {
              retention_in_days = try(var.logs.http_logs.azure_blob_storage.retention_in_days, false)
              sas_url           = try(var.logs.http_logs.azure_blob_storage.sas_url, false)
            }
          }

          dynamic "file_system" {
            for_each = try(var.logs.http_logs.file_system, null) != null ? [1] : []

            content {
              retention_in_days = try(var.logs.http_logs.file_system.retention_in_days, false)
              retention_in_mb   = try(var.logs.http_logs.file_system.retention_in_mb, false)
            }
          }
        }
      }
    }
  }

  dynamic "site_config" {
    for_each = try(var.site_config, null) != null ? [1] : []

    content {
      always_on                                     = try(var.site_config.always_on, true)
      api_management_api_id                         = try(var.site_config.api_management_api_id, null)
      app_command_line                              = try(var.site_config.app_command_line, null)
      container_registry_managed_identity_client_id = try(var.site_config.container_registry_managed_identity_client_id, null)
      container_registry_use_managed_identity       = try(var.site_config.container_registry_use_managed_identity, false)
      ftps_state                                    = try(var.site_config.ftps_state, null)
      health_check_path                             = try(var.site_config.health_check_path, null)
      health_check_eviction_time_in_min             = try(var.site_config.health_check_eviction_time_in_min, null)
      http2_enabled                                 = try(var.site_config.http2_enabled, null)
      load_balancing_mode                           = try(var.site_config.load_balancing_mode, null)
      managed_pipeline_mode                         = try(var.site_config.managed_pipeline_mode, null)
      minimum_tls_version                           = try(var.site_config.minimum_tls_version, null)
      remote_debugging_enabled                      = try(var.site_config.remote_debugging_enabled, null)
      remote_debugging_version                      = try(var.site_config.remote_debugging_version, null)
      scm_minimum_tls_version                       = try(var.site_config.scm_minimum_tls_version, null)
      scm_use_main_ip_restriction                   = try(var.site_config.scm_use_main_ip_restriction, null)
      use_32_bit_worker                             = try(var.site_config.use_32_bit_worker, null)
      websockets_enabled                            = try(var.site_config.websockets_enabled, null)
      vnet_route_all_enabled                        = try(var.site_config.vnet_route_all_enabled, null)
      worker_count                                  = try(var.site_config.worker_count, null)
      auto_heal_enabled                             = try(var.site_config.aut_heal_setting, null)

      dynamic "auto_heal_setting" {
        for_each = try(var.site_config.auto_heal_setting, null) != null ? [1] : []

        content {
          dynamic "action" {
            for_each = try(var.site_config.auto_heal_setting.action, null) != null ? [1] : []

            content {
              action_type                    = try(var.site_config.auto_heal_setting.action.action_type, null)
              minimum_process_execution_time = try(var.site_config.auto_heal_setting.action.minimum_process_execution_time, null)
            }
          }

          dynamic "trigger" {
            for_each = try(var.site_config.auto_heal_setting.trigger, null) != null ? [1] : []

            content {
              dynamic "requests" {
                for_each = try(var.site_config.auto_heal_setting.trigger.requests, null) != null ? [1] : []

                content {
                  count    = try(var.site_config.auto_heal_setting.trigger.requests.count, null)
                  interval = try(var.site_config.auto_heal_setting.trigger.requests.interval, null)
                }
              }

              dynamic "slow_request" {
                for_each = try(var.site_config.auto_heal_setting.trigger.slow_request, null) != null ? [1] : []

                content {
                  count      = try(var.site_config.auto_heal_setting.trigger.slow_request.count, null)
                  interval   = try(var.site_config.auto_heal_setting.trigger.slow_request.interval, null)
                  time_taken = try(var.site_config.auto_heal_setting.trigger.slow_request.time_taken, null)
                  path       = try(var.site_config.auto_heal_setting.trigger.slow_request.path, null)
                }
              }

              dynamic "status_code" {
                for_each = try(var.site_config.auto_heal_setting.trigger.status_code, null) != null ? [1] : []

                content {
                  count             = try(var.site_config.auto_heal_setting.trigger.status_code.count, null)
                  interval          = try(var.site_config.auto_heal_setting.trigger.status_code.interval, null)
                  status_code_range = try(var.site_config.auto_heal_setting.trigger.status_code.status_code_range, null)
                  sub_status        = try(var.site_config.auto_heal_setting.trigger.status_code.sub_status, null)
                  path              = try(var.site_config.auto_heal_setting.trigger.status_code.path, null)
                }
              }
            }
          }
        }
      }

      dynamic "application_stack" {
        for_each = try(var.site_config.application_stack, null) != null ? [1] : []

        content {
          current_stack             = try(var.site_config.application_stack.current_stack, null)
          docker_container_name     = try(var.site_config.application_stack.docker_container_name, null)
          docker_container_registry = try(var.site_config.application_stack.docker_container_registry, null)
          docker_container_tag      = try(var.site_config.application_stack.docker_container_tag, null)
          dotnet_core_version       = try(var.site_config.application_stack.dotnet_core_version, null)
          dotnet_version            = try(var.site_config.application_stack.dotnet_version, null)
          java_version              = try(var.site_config.application_stack.java_version, null)
          node_version              = try(var.site_config.application_stack.node_version, null)
          php_version               = try(var.site_config.application_stack.php_version, null)
          python_version            = try(var.site_config.application_stack.python_version, null)
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
          ip_address                = try(ip_restriction.value.ip_address, null)
          service_tag               = try(ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(ip_restriction.value.name, null)
          priority                  = try(ip_restriction.value.priority, null)
          action                    = try(ip_restriction.value.action, null)

          dynamic "headers" {
            for_each = try(ip_restriction.value.headers, [])

            content {
              x_azure_fdid      = try(headers.value.x_azure_fdid, null)
              x_fd_health_probe = try(headers.value.x_fd_health_prob, null)
              x_forwarded_for   = try(headers.value.x_forwarded_for, null)
              x_forwarded_host  = try(headers.value.x_forwarded_host, null)
            }
          }
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = try(var.site_config.scm_ip_restriction, [])

        content {
          ip_address                = try(scm_ip_restriction.value.ip_address, null)
          service_tag               = try(scm_ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(scm_ip_restriction.value.name, null)
          priority                  = try(scm_ip_restriction.value.priority, null)
          action                    = try(scm_ip_restriction.value.action, null)

          dynamic "headers" {
            for_each = try(scm_ip_restriction.value.headers, [])

            content {
              x_azure_fdid      = try(headers.value.x_azure_fdid, null)
              x_fd_health_probe = try(headers.value.x_fd_health_prob, null)
              x_forwarded_for   = try(headers.value.x_forwarded_for, null)
              x_forwarded_host  = try(headers.value.x_forwarded_host, null)
            }
          }
        }
      }

      dynamic "virtual_application" {
        for_each = try(var.site_config.virtual_application, [])

        content {
          physical_path = try(virtual_application.value.physical_path, null)
          preload       = try(virtual_application.value.preload, null)
          virtual_path  = try(virtual_application.value.virtual_path, null)

          dynamic "virtual_directory" {
            for_each = try(virtual_application.value.virtual_directory, [])

            content {
              physical_path = try(virtual_directory.value.physical_path, null)
              virtual_path  = try(virtual_directory.value.virtual_path, null)
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
      connection_string_names = try(var.sticky_settings.connection_string_name, false)
    }
  }

  dynamic "storage_account" {
    for_each = try(var.storage_account, {})

    content {
      access_key   = try(storage_account.value.access_key, null)
      account_name = try(storage_account.value.account_name, null)
      name         = try(storage_account.value.name, null)
      share_name   = try(storage_account.value.share_name, null)
      type         = try(storage_account.value.type, null)
      mount_path   = try(storage_account.value.mount_path, null)
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

#---------------------------------------------------------
# Windows Web App Service Custom Hostname Bindings 
#---------------------------------------------------------
resource "azurerm_app_service_custom_hostname_binding" "app_service" {
  for_each = try(var.custom_hostname_bindings, {})

  app_service_name    = azurerm_windows_web_app.web_app.name
  resource_group_name = var.resource_group_name
  hostname            = each.value.hostname
  ssl_state           = try(each.value.ssl_state, null)
  thumbprint          = try(each.value.thumbprint, null)
}