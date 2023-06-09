module "data_factory" {
  source = "./modules/data_factory/data_factory"
  depends_on = [
    module.resource_groups
  ]

  for_each = local.data_factory.data_factory

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  diagnostics         = try(each.value.diagnostics, null)
  diagnostic_profiles = try(each.value.diagnostic_profiles, {})
  identity            = try(each.value.identity, {})
  resource_groups     = module.resource_groups
  virtual_subnets     = module.virtual_subnets
  private_endpoints   = try(each.value.private_endpoints, {})
  private_dns         = try(data.azurerm_private_dns_zone.dns, {})
  settings            = each.value
}

output "data_factory" {
  value = module.data_factory
}

##### azurerm_data_factory_pipeline
module "data_factory_pipeline" {
  source   = "./modules/data_factory/data_factory_pipeline"
  for_each = local.data_factory.data_factory_pipeline

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
  settings        = each.value
}

output "data_factory_pipeline" {
  value = module.data_factory_pipeline
}

##### azurerm_data_factory_trigger_schedule
module "data_factory_trigger_schedule" {
  source   = "./modules/data_factory/data_factory_trigger_schedule"
  for_each = local.data_factory.data_factory_trigger_schedule

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
  pipeline_name   = can(each.value.data_factory_pipeline.name) ? each.value.data_factory_pipeline.name : module.data_factory_pipeline[each.value.data_factory_pipeline.key].name
  settings        = each.value
}

output "data_factory_trigger_schedule" {
  value = module.data_factory_trigger_schedule
}

module "data_factory_integration_runtime_self_hosted" {
  source   = "./modules/data_factory/data_factory_integration_runtime_self_hosted"
  for_each = local.data_factory.data_factory_integration_runtime_self_hosted

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
}

output "data_factory_integration_runtime_self_hosted" {
  value = module.data_factory_integration_runtime_self_hosted
}

module "data_factory_integration_runtime_azure_ssis" {
  source   = "./modules/data_factory/data_factory_integration_runtime_azure_ssis"
  for_each = local.data_factory.data_factory_integration_runtime_azure_ssis

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(lookup(each.value, "tags", {}), var.tags, local.global_settings.tags, )

  data_factory_id = can(each.value.data_factory.id) ? each.value.data_factory.id : module.data_factory[try(each.value.data_factory.key, each.value.data_factory_key)].id
  settings        = each.value

  remote_objects = {
    resource_groups          = local.combined_objects.resource_groups
    keyvaults                = local.combined_objects.keyvaults
    dynamic_keyvault_secrets = local.security.dynamic_keyvault_secrets
  }
}

output "data_factory_integration_runtime_azure_ssis" {
  value = module.data_factory_integration_runtime_azure_ssis
}