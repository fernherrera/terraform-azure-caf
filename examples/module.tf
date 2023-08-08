module "example" {
  source = "../"

  # providers = {
  #   azurerm.connectivity = azurerm.connectivity
  #   azurerm.management   = azurerm.management
  # }

  global_settings = var.global_settings
  client_config   = var.client_config
  environment     = var.environment
  tags            = local.tags

  # # Defaulted, you can declare an override if you dont target Azure public
  # cloud = var.cloud

  # Azure Resources
  #------------------------------------------------------------------
  analysis_services = var.analysis_services
  apim              = var.apim
  compute           = var.compute
  containers        = var.containers
  database          = var.database
  data_factory      = var.data_factory
  messaging         = var.messaging
  networking        = var.networking
  remote_objects    = var.remote_objects
  resource_groups   = var.resource_groups
  security          = var.security
  shared_services   = var.shared_services
  storage           = var.storage
  web               = var.web
}