resource "azurerm_data_factory_linked_service_azure_databricks" "dflsad" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  data_factory_id            = var.data_factory_id
  adb_domain                 = format("https://%s", var.databricks_workspace_url)
  access_token               = try(var.settings.access_token, null)
  msi_work_space_resource_id = try(var.databricks_workspace_id, null)
  existing_cluster_id        = try(var.settings.existing_cluster_id, null)
  additional_properties      = try(var.settings.additional_properties, null)
  annotations                = try(var.settings.annotations, null)
  description                = try(var.settings.description, null)
  integration_runtime_name   = try(var.settings.integration_runtime_name, var.integration_runtime_name)
  parameters                 = try(var.settings.parameters, null)

  dynamic "instance_pool" {
    for_each = try(var.settings.instance_pool, null) != null ? [var.settings.instance_pool] : []

    content {
      instance_pool_id      = try(instance_pool.value.instance_pool_id, null)
      cluster_version       = try(instance_pool.value.cluster_version, null)
      min_number_of_workers = try(instance_pool.value.min_number_of_workers, null)
      max_number_of_workers = try(instance_pool.value.max_number_of_workers, null)
    }
  }

  dynamic "key_vault_password" {
    for_each = try(var.settings.key_vault_password, null) != null ? [var.settings.key_vault_password] : []

    content {
      linked_service_name = try(key_vault_password.value.linked_service_name, null)
      secret_name         = try(key_vault_password.value.secret_name, null)
    }
  }

  dynamic "new_cluster_config" {
    for_each = try(var.settings.new_cluster_config, null) != null ? [var.settings.new_cluster_config] : []

    content {
      cluster_version             = try(new_cluster_config.value.cluster_version, null)
      node_type                   = try(new_cluster_config.value.node_type, null)
      custom_tags                 = try(new_cluster_config.value.custom_tags, null)
      driver_node_type            = try(new_cluster_config.value.driver_node_type, null)
      init_scripts                = try(new_cluster_config.value.init_scripts, null)
      log_destination             = try(new_cluster_config.value.log_destination, null)
      spark_config                = try(new_cluster_config.value.spark_config, null)
      spark_environment_variables = try(new_cluster_config.value.spark_environment_variables, null)

      min_number_of_workers = try(new_cluster_config.value.min_number_of_workers, null)
      max_number_of_workers = try(new_cluster_config.value.max_number_of_workers, null)

    }
  }
}