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

data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}

# The following client config resources are used to dynamically extract 
# connection settings from from the environment.

data "azurerm_client_config" "current" {}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}

data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}