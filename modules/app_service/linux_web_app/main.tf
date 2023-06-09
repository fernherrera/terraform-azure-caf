#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )

  app_settings = merge(try(var.app_settings, {}), var.application_insight == null ? {} :
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY"             = var.application_insight.instrumentation_key,
      "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.application_insight.connection_string,
      "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2",
      "WEBSITE_LOAD_CERTIFICATES"                  = "*"
    }
  )

  backup_storage_account = can(var.settings.backup.storage_account_key) ? var.storage_accounts[var.settings.backup.storage_account_key] : null
  backup_sas_url         = can(var.settings.backup.storage_account_key) ? "${local.backup_storage_account.primary_blob_endpoint}${local.backup_storage_account.containers[var.settings.backup.container_key].name}${data.azurerm_storage_account_blob_container_sas.backup[0].sas}" : null

  logs_storage_account = can(var.settings.logs.storage_account_key) ? var.storage_accounts[var.settings.logs.storage_account_key] : null
  logs_sas_url         = can(var.settings.logs.storage_account_key) ? "${local.logs_storage_account.primary_blob_endpoint}${local.logs_storage_account.containers[var.settings.logs.container_key].name}${data.azurerm_storage_account_blob_container_sas.logs[0].sas}" : null

  http_logs_storage_account = can(var.settings.logs.http_logs.storage_account_key) ? var.storage_accounts[var.settings.logs.http_logs.storage_account_key] : null
  http_logs_sas_url         = can(var.settings.logs.http_logs.storage_account_key) ? "${local.http_logs_storage_account.primary_blob_endpoint}${local.http_logs_storage_account.containers[var.settings.logs.http_logs.container_key].name}${data.azurerm_storage_account_blob_container_sas.http_logs[0].sas}" : null
}

#----------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#---------------------------------------------------------
# Linux Web App Service 
#---------------------------------------------------------
resource "azurerm_linux_web_app" "web_app" {
  name                = var.name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags

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
    for_each = lookup(var.settings, "auth_settings", {}) != {} ? [1] : []

    content {
      enabled                        = lookup(var.settings.auth_settings, "enabled", false)
      additional_login_parameters    = lookup(var.settings.auth_settings, "additional_login_parameters", null)
      allowed_external_redirect_urls = lookup(var.settings.auth_settings, "allowed_external_redirect_urls", null)
      default_provider               = lookup(var.settings.auth_settings, "default_provider", null)
      issuer                         = lookup(var.settings.auth_settings, "issuer", null)
      runtime_version                = lookup(var.settings.auth_settings, "runtime_version", null)
      token_refresh_extension_hours  = lookup(var.settings.auth_settings, "token_refresh_extension_hours", null)
      token_store_enabled            = lookup(var.settings.auth_settings, "token_store_enabled", null)
      unauthenticated_client_action  = lookup(var.settings.auth_settings, "unauthenticated_client_action", null)

      dynamic "active_directory" {
        for_each = lookup(var.settings.auth_settings, "active_directory", {}) != {} ? [1] : []

        content {
          client_id         = var.settings.auth_settings.active_directory.client_id
          client_secret     = lookup(var.settings.auth_settings.active_directory, "client_secret", null)
          allowed_audiences = lookup(var.settings.auth_settings.active_directory, "allowed_audiences", null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(var.settings.auth_settings, "facebook", {}) != {} ? [1] : []

        content {
          app_id       = var.settings.auth_settings.facebook.app_id
          app_secret   = var.settings.auth_settings.facebook.app_secret
          oauth_scopes = lookup(var.settings.auth_settings.facebook, "oauth_scopes", null)
        }
      }

      dynamic "google" {
        for_each = lookup(var.settings.auth_settings, "google", {}) != {} ? [1] : []

        content {
          client_id     = var.settings.auth_settings.google.client_id
          client_secret = var.settings.auth_settings.google.client_secret
          oauth_scopes  = lookup(var.settings.auth_settings.google, "oauth_scopes", null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(var.settings.auth_settings, "microsoft", {}) != {} ? [1] : []

        content {
          client_id     = var.settings.auth_settings.microsoft.client_id
          client_secret = var.settings.auth_settings.microsoft.client_secret
          oauth_scopes  = lookup(var.settings.auth_settings.microsoft, "oauth_scopes", null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(var.settings.auth_settings, "twitter", {}) != {} ? [1] : []

        content {
          consumer_key    = var.settings.auth_settings.twitter.consumer_key
          consumer_secret = var.settings.auth_settings.twitter.consumer_secret
        }
      }

      dynamic "github" {
        for_each = lookup(var.settings.auth_settings, "github", {}) != {} ? [1] : []

        content {
          client_id                  = var.settings.auth_settings.github.client_id
          client_secret              = var.settings.auth_settings.github.client_secret
          client_secret_setting_name = var.settings.auth_settings.github.client_secret_setting_name
          oauth_scopes               = lookup(var.settings.auth_settings.github, "oauth_scopes", null)
        }
      }
    }
  }

  dynamic "backup" {
    for_each = lookup(var.settings, "backup", {}) != {} ? [1] : []

    content {
      name                = var.settings.backup.name
      enabled             = var.settings.backup.enabled
      storage_account_url = try(var.settings.backup.storage_account_url, local.backup_sas_url)

      dynamic "schedule" {
        for_each = lookup(var.settings.backup, "schedule", {}) != {} ? [1] : []

        content {
          frequency_interval       = var.settings.backup.schedule.frequency_interval
          frequency_unit           = lookup(var.settings.backup.schedule, "frequency_unit", null)
          keep_at_least_one_backup = lookup(var.settings.backup.schedule, "keep_at_least_one_backup", null)
          retention_period_days    = lookup(var.settings.backup.schedule, "retention_period_days", null)
          start_time               = lookup(var.settings.backup.schedule, "start_time", null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }

  dynamic "identity" {
    for_each = length(local.managed_identities) == 0 && local.identity_type == "SystemAssigned" ? [local.identity_type] : []

    content {
      type = local.identity_type
    }
  }

  dynamic "identity" {
    for_each = length(local.managed_identities) > 0 || local.identity_type == "UserAssigned" ? [local.identity_type] : []

    content {
      type         = local.identity_type
      identity_ids = lower(local.identity_type) == "userassigned" ? local.managed_identities : null
    }
  }

  dynamic "logs" {
    for_each = lookup(var.settings, "logs", {}) != {} ? [1] : []

    content {
      detailed_error_messages = lookup(var.settings.logs, "detailed_error_messages", false)
      failed_request_tracing  = lookup(var.settings.logs, "failed_request_tracing", false)

      dynamic "application_logs" {
        for_each = lookup(var.settings.logs, "application_logs", {}) != {} ? [1] : []

        content {
          file_system_level = try(var.settings.logs.application_logs.file_system_level, null)

          dynamic "azure_blob_storage" {
            for_each = lookup(var.settings.logs.application_logs, "azure_blob_storage", {}) != {} ? [1] : []

            content {
              level             = var.settings.logs.application_logs.azure_blob_storage.level
              retention_in_days = var.settings.logs.application_logs.azure_blob_storage.retention_in_days
              sas_url           = try(var.settings.logs.application_logs.azure_blob_storage.sas_url, local.logs_sas_url)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(var.settings.logs, "http_logs", {}) != {} ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(var.settings.logs.http_logs, "azure_blob_storage", {}) != {} ? [1] : []

            content {
              retention_in_days = lookup(var.settings.logs.http_logs.azure_blob_storage, "retention_in_days", false)
              sas_url           = lookup(var.settings.logs.http_logs.azure_blob_storage, "sas_url", false)
            }
          }

          dynamic "file_system" {
            for_each = lookup(var.settings.logs.http_logs, "file_system", {}) != {} ? [1] : []

            content {
              retention_in_days = lookup(var.settings.logs.http_logs.file_system, "retention_in_days", false)
              retention_in_mb   = lookup(var.settings.logs.http_logs.file_system, "retention_in_mb", false)
            }
          }
        }
      }
    }
  }

  dynamic "site_config" {
    for_each = lookup(var.settings, "site_config", {}) != {} ? [1] : []

    content {
      always_on                                     = lookup(var.settings.site_config, "always_on", true)
      api_management_api_id                         = lookup(var.settings.site_config, "api_management_api_id", null)
      app_command_line                              = lookup(var.settings.site_config, "app_command_line", null)
      container_registry_managed_identity_client_id = lookup(var.settings.site_config, "container_registry_managed_identity_client_id", null)
      container_registry_use_managed_identity       = lookup(var.settings.site_config, "container_registry_use_managed_identity", false)
      ftps_state                                    = lookup(var.settings.site_config, "ftps_state", null)
      health_check_path                             = lookup(var.settings.site_config, "health_check_path", null)
      health_check_eviction_time_in_min             = lookup(var.settings.site_config, "health_check_eviction_time_in_min", null)
      http2_enabled                                 = lookup(var.settings.site_config, "http2_enabled", null)
      load_balancing_mode                           = lookup(var.settings.site_config, "load_balancing_mode", null)
      managed_pipeline_mode                         = lookup(var.settings.site_config, "managed_pipeline_mode", null)
      minimum_tls_version                           = lookup(var.settings.site_config, "minimum_tls_version", null)
      remote_debugging_enabled                      = lookup(var.settings.site_config, "remote_debugging_enabled", null)
      remote_debugging_version                      = lookup(var.settings.site_config, "remote_debugging_version", null)
      scm_minimum_tls_version                       = lookup(var.settings.site_config, "scm_minimum_tls_version", null)
      scm_use_main_ip_restriction                   = lookup(var.settings.site_config, "scm_use_main_ip_restriction", null)
      use_32_bit_worker                             = lookup(var.settings.site_config, "use_32_bit_worker", null)
      websockets_enabled                            = lookup(var.settings.site_config, "websockets_enabled", null)
      vnet_route_all_enabled                        = lookup(var.settings.site_config, "vnet_route_all_enabled", null)
      worker_count                                  = lookup(var.settings.site_config, "worker_count", null)
      auto_heal_enabled                             = lookup(var.settings.site_config, "aut_heal_setting", null)

      dynamic "auto_heal_setting" {
        for_each = lookup(var.settings.site_config, "auto_heal_setting", {}) != {} ? [1] : []

        content {
          dynamic "action" {
            for_each = lookup(var.settings.site_config.auto_heal_setting, "action", {}) != {} ? [1] : []

            content {
              action_type                    = lookup(var.settings.site_config.auto_heal_setting.action, "action_type", null)
              minimum_process_execution_time = lookup(var.settings.site_config.auto_heal_setting.action, "minimum_process_execution_time", null)
            }
          }

          dynamic "trigger" {
            for_each = lookup(var.settings.site_config.auto_heal_setting, "trigger", {}) != {} ? [1] : []

            content {
              dynamic "requests" {
                for_each = lookup(var.settings.site_config.auto_heal_setting.trigger, "requests", {}) != {} ? [1] : []

                content {
                  count    = lookup(var.settings.site_config.auto_heal_setting.trigger.requests, "count", null)
                  interval = lookup(var.settings.site_config.auto_heal_setting.trigger.requests, "interval", null)
                }
              }

              dynamic "slow_request" {
                for_each = lookup(var.settings.site_config.auto_heal_setting.trigger, "slow_request", {}) != {} ? [1] : []

                content {
                  count      = lookup(var.settings.site_config.auto_heal_setting.trigger.slow_request, "count", null)
                  interval   = lookup(var.settings.site_config.auto_heal_setting.trigger.slow_request, "interval", null)
                  time_taken = lookup(var.settings.site_config.auto_heal_setting.trigger.slow_request, "time_taken", null)
                  path       = lookup(var.settings.site_config.auto_heal_setting.trigger.slow_request, "path", null)
                }
              }

              dynamic "status_code" {
                for_each = lookup(var.settings.site_config.auto_heal_setting.trigger, "status_code", {}) != {} ? [1] : []

                content {
                  count             = lookup(var.settings.site_config.auto_heal_setting.trigger.status_code, "count", null)
                  interval          = lookup(var.settings.site_config.auto_heal_setting.trigger.status_code, "interval", null)
                  status_code_range = lookup(var.settings.site_config.auto_heal_setting.trigger.status_code, "status_code_range", null)
                  sub_status        = lookup(var.settings.site_config.auto_heal_setting.trigger.status_code, "sub_status", null)
                  win32_status      = lookup(var.settings.site_config.auto_heal_setting.trigger.status_code, "win32_status", null)
                  path              = lookup(var.settings.site_config.auto_heal_setting.trigger.status_code, "path", null)
                }
              }
            }
          }
        }
      }

      dynamic "application_stack" {
        for_each = lookup(var.settings.site_config, "application_stack", {}) != {} ? [1] : []

        content {
          docker_image        = lookup(var.settings.site_config.application_stack, "docker_image", null)
          docker_image_tag    = lookup(var.settings.site_config.application_stack, "docker_image_tag", null)
          dotnet_version      = lookup(var.settings.site_config.application_stack, "dotnet_version", null)
          go_version          = lookup(var.settings.site_config.application_stack, "go_version", null)
          java_server         = lookup(var.settings.site_config.application_stack, "java_server", null)
          java_server_version = lookup(var.settings.site_config.application_stack, "java_server_version", null)
          java_version        = lookup(var.settings.site_config.application_stack, "java_version", null)
          node_version        = lookup(var.settings.site_config.application_stack, "node_version", null)
          php_version         = lookup(var.settings.site_config.application_stack, "php_version", null)
          python_version      = lookup(var.settings.site_config.application_stack, "python_version", null)
          ruby_version        = lookup(var.settings.site_config.application_stack, "ruby_version", null)
        }
      }

      dynamic "cors" {
        for_each = lookup(var.settings.site_config, "cors", {}) != {} ? [1] : []

        content {
          allowed_origins     = lookup(var.settings.site_config.cors, "allowed_origins", null)
          support_credentials = lookup(var.settings.site_config.cors, "support_credentials", null)
        }
      }

      dynamic "ip_restriction" {
        for_each = try(var.settings.site_config.ip_restriction, [])

        content {
          ip_address                = try(ip_restriction.value.ip_address, null)
          service_tag               = try(ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(ip_restriction.value.name, null)
          priority                  = try(ip_restriction.value.priority, null)
          action                    = try(ip_restriction.value.actuib, null)

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
        for_each = try(var.settings.site_config.scm_ip_restriction, [])

        content {
          ip_address                = try(scm_ip_restriction.value.ip_address, null)
          service_tag               = try(scm_ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(scm_ip_restriction.value.name, null)
          priority                  = try(scm_ip_restriction.value.priority, null)
          action                    = try(scm_ip_restriction.value.actuib, null)

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
    }
  }

  dynamic "sticky_settings" {
    for_each = lookup(var.settings, "sticky_settings", {}) != {} ? [1] : []

    content {
      app_setting_names       = lookup(var.settings.sticky_settings, "app_setting_names", false)
      connection_string_names = lookup(var.settings.sticky_settings, "connection_string_name", false)
    }
  }

  dynamic "storage_account" {
    for_each = lookup(var.settings, "storage_account", {}) != {} ? [1] : []

    content {
      access_key   = can(var.settings.storage_account.storage_account_key) ? try(var.storage_accounts[var.settings.storage_account.storage_account_key].primary_access_key, null) : lookup(var.settings.storage_account, "access_key", null)
      account_name = can(var.settings.storage_account.storage_account_key) ? try(var.storage_accounts[var.settings.storage_account.storage_account_key].name, null) : lookup(var.settings.storage_account, "account_name", null)
      name         = lookup(var.settings.storage_account, "name", null)
      share_name   = lookup(var.settings.storage_account, "share_name", null)
      type         = lookup(var.settings.storage_account, "type", null)
      mount_path   = lookup(var.settings.storage_account, "mount_path", null)
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
# Linux Web App Custom hostname bindings
#---------------------------------------------------------
resource "azurerm_app_service_custom_hostname_binding" "app_service" {
  for_each = try(var.settings.custom_hostname_binding, {})

  app_service_name    = azurerm_linux_web_app.web_app.name
  resource_group_name = local.resource_group_name
  hostname            = each.value.hostname
  ssl_state           = try(each.value.ssl_state, null)
  thumbprint          = try(each.value.thumbprint, null)
}

#---------------------------------------------------------
# Linux Web App Source Control Configuration.
#---------------------------------------------------------
resource "azurerm_app_service_source_control" "scm" {
  for_each = try(var.settings.source_control, {})

  app_id   = azurerm_linux_web_app.web_app.id
  repo_url = try(var.settings.source_control.repo_url, null)
  branch   = try(var.settings.source_control.branch, "main")

  use_manual_integration = try(var.settings.source_control.use_manual_integration, false)
  rollback_enabled       = try(var.settings.source_control.rollback_enabled, false)
  use_local_git          = try(var.settings.source_control.use_local_git, null)
  use_mercurial          = try(var.settings.source_control.use_mercurial, null)

  dynamic "github_action_configuration" {
    for_each = try(var.settings.source_control.github_action_configuration, {}) != {} ? [1] : []

    content {
      generate_workflow_file = try(var.settings.source_control.github_action_configuration.generate_workflow_file, true)

      dynamic "code_configuration" {
        for_each = try(var.settings.source_control.github_action_configuration.code_configuration, {}) != {} ? [1] : []

        content {
          runtime_stack   = var.settings.source_control.github_action_configuration.code_configuration.runtime_stack
          runtime_version = var.settings.source_control.github_action_configuration.code_configuration.runtime_version
        }
      }

      dynamic "container_configuration" {
        for_each = try(var.settings.source_control.github_action_configuration.container_configuration, {}) != {} ? [1] : []

        content {
          image_name        = var.settings.source_control.github_action_configuration.container_configuration.image_name
          registry_url      = var.settings.source_control.github_action_configuration.container_configuration.registry_url
          registry_password = try(var.settings.source_control.github_action_configuration.container_configuration.registry_password, null)
          registry_username = try(var.settings.source_control.github_action_configuration.container_configuration.registry_username, null)
        }
      }
    }
  }
}