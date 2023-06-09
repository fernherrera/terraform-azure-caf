#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = local.tags
}

#----------------------------------------------------------
# Get Key Vault secrets
#----------------------------------------------------------
data "azurerm_key_vault_secret" "administrator_password" {
  for_each = try(var.settings.catalog_info.keyvault.keyvault_key, null) != null && (try(var.settings.catalog_info.keyvault.secret_name, null) != null || try(var.settings.catalog_info.keyvault.secret_key, null) != null) ? toset(["enabled"]) : toset([])

  key_vault_id = var.remote_objects.keyvaults[var.settings.catalog_info.keyvault.key].id
  name         = can(var.settings.catalog_info.keyvault.secret_name) ? var.settings.catalog_info.keyvault.secret_name : var.remote_objects.dynamic_keyvault_secrets[var.settings.catalog_info.keyvault.key][var.settings.catalog_info.keyvault.secret_key].secret_name
}

#----------------------------------------------------------
# Data Factory Creation 
#----------------------------------------------------------
resource "azurerm_data_factory_integration_runtime_azure_ssis" "dfiras" {
  name     = var.name
  location = local.location

  data_factory_id                  = var.data_factory_id
  node_size                        = var.settings.node_size
  number_of_nodes                  = try(var.settings.number_of_nodes, null)
  max_parallel_executions_per_node = try(var.settings.max_parallel_executions_per_node, null)
  edition                          = try(var.settings.edition, null)
  license_type                     = try(var.settings.license_type, null)
  description                      = try(var.settings.description, null)

  dynamic "catalog_info" {
    for_each = try(var.settings.catalog_info, null) != null ? [var.settings.catalog_info] : []

    content {
      server_endpoint        = can(catalog_info.value.server_endpoint) ? catalog_info.value.server_endpoint : var.remote_objects.mssql_servers[try(catalog_info.value.mssql_server.lz_key, var.client_config.landingzone_key)][catalog_info.value.mssql_server.key].fully_qualified_domain_name
      administrator_login    = catalog_info.value.administrator_login
      administrator_password = can(catalog_info.keyvault.administrator_password) ? catalog_info.keyvault.administrator_password : azurerm_key_vault_secret.administrator_password
      pricing_tier           = catalog_info.value.pricing_tier
      dual_standby_pair_name = catalog_info.value.dual_standby_pair_name
    }
  }

  dynamic "custom_setup_script" {
    for_each = try(var.settings.custom_setup_script, null) != null ? [var.settings.custom_setup_script] : []

    content {
      blob_container_uri = custom_setup_script.value.blob_container_uri
      sas_token          = custom_setup_script.value.sas_token
    }
  }

  dynamic "express_custom_setup" {
    for_each = try(var.settings.express_custom_setup, null) != null ? [var.settings.express_custom_setup] : []

    content {
      environment        = express_custom_setup.value.environment
      powershell_version = express_custom_setup.value.powershell_version

      dynamic "command_key" {
        for_each = try(var.settings.express_custom_setup.command_key, null) != null ? [var.settings.express_custom_setup.command_key] : []

        content {
          target_name = var.settings.express_custom_setup.target_name
          user_name   = var.settings.express_custom_setup.user_name
          password    = try(var.settings.express_custom_setup.password, null)

          dynamic "key_vault_password" {
            for_each = try(var.settings.express_custom_setup.command_key.key_vault_password, null) != null ? [var.settings.express_custom_setup.command_key.key_vault_password] : []

            content {
              linked_service_name = var.settings.express_custom_setup.command_key.key_vault_password.linked_service_name
              secret_name         = try(var.settings.express_custom_setup.command_key.key_vault_password.secret_name)
              secret_version      = try(var.settings.express_custom_setup.command_key.key_vault_password.secret_version)
              parameters          = try(var.settings.express_custom_setup.command_key.key_vault_password.parameters)
            }
          }
        }
      }

      dynamic "component" {
        for_each = try(var.settings.express_custom_setup.component, null) != null ? [var.settings.express_custom_setup.component] : []

        content {
          name    = var.settings.express_custom_setup.component.name
          license = var.settings.express_custom_setup.component.license

          dynamic "key_vault_license" {
            for_each = try(var.settings.express_custom_setup.component.key_vault_password, null) != null ? [var.settings.express_custom_setup.command_key.key_vault_password] : []

            content {
              linked_service_name = var.settings.express_custom_setup.component.key_vault_license.linked_service_name
              secret_name         = try(var.settings.express_custom_setup.component.key_vault_license.secret_name)
              secret_version      = try(var.settings.express_custom_setup.component.key_vault_license.secret_version)
              parameters          = try(var.settings.express_custom_setup.component.key_vault_license.parameters)
            }
          }
        }
      }
    }
  }

  dynamic "package_store" {
    for_each = try(var.settings.package_store, null) != null ? [var.settings.package_store] : []

    content {
      name                = package_store.value.name
      linked_service_name = package_store.value.linked_service_name
    }
  }

  dynamic "proxy" {
    for_each = try(var.settings.proxy, null) != null ? [var.settings.proxy] : []

    content {
      self_hosted_integration_runtime_name = proxy.value.self_hosted_integration_runtime_name
      staging_storage_linked_service_name  = proxy.value.staging_storage_linked_service_name
      path                                 = proxy.value.path
    }
  }

  dynamic "vnet_integration" {
    for_each = try(var.settings.vnet_integration, null) != null ? [var.settings.vnet_integration] : []

    content {
      vnet_id     = try(vnet_integration.value.vnet_id, null)
      subnet_name = try(vnet_integration.value.subnet_name, null)
      subnet_id   = try(vnet_integration.value.subnet_id, null)
      public_ips  = try(vnet_integration.value.public_ips, null)
    }
  }
}