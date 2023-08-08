terraform {
  required_version = ">= 1.3.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.59.0"
      configuration_aliases = [
        azurerm.management,
        azurerm.connectivity,
      ]
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.39.0"
    }

    null = {
      source = "hashicorp/null"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }

    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
  }
}


provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_api_management.purge_soft_delete_on_destroy
      # recover_soft_deleted_api_managements = var.provider_azurerm_features_api_management.recover_soft_deleted_api_managements
    }
    # application_insights {
    #   disable_generated_rule = var.provider_azurerm_features_application_insights.disable_generated_rule
    # }
    # cognitive_account {
    #   purge_soft_delete_on_destroy = var.provider_azurerm_features_cognitive_account.purge_soft_delete_on_destroy
    # }
    key_vault {
      purge_soft_delete_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_delete_on_destroy
      # purge_soft_deleted_certificates_on_destroy = var.provider_azurerm_features_keyvault.purge_soft_deleted_certificates_on_destroy
      # purge_soft_deleted_keys_on_destroy         = var.provider_azurerm_features_keyvault.purge_soft_deleted_keys_on_destroy
      # purge_soft_deleted_secrets_on_destroy      = var.provider_azurerm_features_keyvault.purge_soft_deleted_secrets_on_destroy
      # recover_soft_deleted_certificates          = var.provider_azurerm_features_keyvault.recover_soft_deleted_certificates
      recover_soft_deleted_key_vaults = try(var.provider_azurerm_features_keyvault.recover_soft_deleted_key_vaults, null)
      # recover_soft_deleted_keys                  = var.provider_azurerm_features_keyvault.recover_soft_deleted_keys
      # recover_soft_deleted_secrets               = var.provider_azurerm_features_keyvault.recover_soft_deleted_secrets
    }
    # log_analytics_workspace {
    #   permanently_delete_on_destroy = var.provider_azurerm_features_log_analytics_workspace.permanently_delete_on_destroy
    # }
    resource_group {
      prevent_deletion_if_contains_resources = var.provider_azurerm_features_resource_group.prevent_deletion_if_contains_resources
    }
    template_deployment {
      delete_nested_items_during_deletion = var.provider_azurerm_features_template_deployment.delete_nested_items_during_deletion
    }
    virtual_machine {
      delete_os_disk_on_deletion     = var.provider_azurerm_features_virtual_machine.delete_os_disk_on_deletion
      graceful_shutdown              = var.provider_azurerm_features_virtual_machine.graceful_shutdown
      skip_shutdown_and_force_delete = var.provider_azurerm_features_virtual_machine.skip_shutdown_and_force_delete
    }
    virtual_machine_scale_set {
      force_delete                  = var.provider_azurerm_features_virtual_machine_scale_set.force_delete
      roll_instances_when_required  = var.provider_azurerm_features_virtual_machine_scale_set.roll_instances_when_required
      scale_to_zero_before_deletion = var.provider_azurerm_features_virtual_machine_scale_set.scale_to_zero_before_deletion
    }
  }
}

provider "azurerm" {
  alias                      = "connectivity"
  skip_provider_registration = true
  subscription_id            = local.subscription_id_connectivity
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = local.subscription_id_management
  features {}
}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

locals {

  # Subscription IDs for other landing zone subscriptions
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)

  tags = merge(var.tags /*, { "azure-caf" = var.rover_version }*/, {})
}
