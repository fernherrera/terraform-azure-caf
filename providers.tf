#--------------------------------------
# Providers
#--------------------------------------

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}

  alias           = "prd_ent"
  subscription_id = "1ff3a5d7-0db3-4659-ae71-c1b5e9344432"
}