locals {
  #------------------------------------------------------------------
  # CAF configuration 
  #------------------------------------------------------------------

  # Subscription IDs for other landing zone subscriptions
  subscription_id_management   = coalesce(var.subscription_id_management, data.azurerm_client_config.current.subscription_id)
  subscription_id_connectivity = coalesce(var.subscription_id_connectivity, local.subscription_id_management)

  # Client Configurations
  client_config = var.client_config == {} ? {
    client_id       = data.azurerm_client_config.current.client_id
    subscription_id = data.azurerm_client_config.current.subscription_id
    tenant_id       = data.azurerm_client_config.current.tenant_id
  } : map(var.client_config)

  # Global Settings
  global_settings = merge({
    default_region     = try(var.global_settings.default_region, "region1")
    environment        = try(var.global_settings.environment, var.environment)
    inherit_tags       = try(var.global_settings.inherit_tags, false)
    passthrough        = try(var.global_settings.passthrough, false)
    prefix             = try(var.global_settings.prefix, null)
    prefix_with_hyphen = try(var.global_settings.prefix_with_hyphen, format("%s-", try(var.global_settings.prefix, "")))
    regions            = try(var.global_settings.regions, null)
    tags               = try(var.global_settings.tags, null)
    use_slug           = try(var.global_settings.use_slug, true)
  }, var.global_settings)

  # Cloud Endpoints
  cloud = merge({
    acrLoginServerEndpoint                      = try(var.cloud.acrLoginServerEndpoint, {})
    attestationEndpoint                         = try(var.cloud.attestationEndpoint, {})
    azureDatalakeAnalyticsCatalogAndJobEndpoint = try(var.cloud.azureDatalakeAnalyticsCatalogAndJobEndpoint, {})
    azureDatalakeStoreFileSystemEndpoint        = try(var.cloud.azureDatalakeStoreFileSystemEndpoint, {})
    keyvaultDns                                 = try(var.cloud.keyvaultDns, {})
    mariadbServerEndpoint                       = try(var.cloud.mariadbServerEndpoint, {})
    mhsmDns                                     = try(var.cloud.mhsmDns, {})
    mysqlServerEndpoint                         = try(var.cloud.mysqlServerEndpoint, {})
    postgresqlServerEndpoint                    = try(var.cloud.postgresqlServerEndpoint, {})
    sqlServerHostname                           = try(var.cloud.sqlServerHostname, {})
    storageEndpoint                             = try(var.cloud.storageEndpoint, {})
    storageSyncEndpoint                         = try(var.cloud.storageSyncEndpoint, {})
    synapseAnalyticsEndpoint                    = try(var.cloud.synapseAnalyticsEndpoint, {})
    activeDirectory                             = try(var.cloud.activeDirectory, {})
    activeDirectoryDataLakeResourceId           = try(var.cloud.activeDirectoryDataLakeResourceId, {})
    activeDirectoryGraphResourceId              = try(var.cloud.activeDirectoryGraphResourceId, {})
    activeDirectoryResourceId                   = try(var.cloud.activeDirectoryResourceId, {})
    appInsightsResourceId                       = try(var.cloud.appInsightsResourceId, {})
    appInsightsTelemetryChannelResourceId       = try(var.cloud.appInsightsTelemetryChannelResourceId, {})
    attestationResourceId                       = try(var.cloud.attestationResourceId, {})
    azmirrorStorageAccountResourceId            = try(var.cloud.azmirrorStorageAccountResourceId, {})
    batchResourceId                             = try(var.cloud.batchResourceId, {})
    gallery                                     = try(var.cloud.gallery, {})
    logAnalyticsResourceId                      = try(var.cloud.logAnalyticsResourceId, {})
    management                                  = try(var.cloud.management, {})
    mediaResourceId                             = try(var.cloud.mediaResourceId, {})
    microsoftGraphResourceId                    = try(var.cloud.microsoftGraphResourceId, {})
    ossrdbmsResourceId                          = try(var.cloud.ossrdbmsResourceId, {})
    portal                                      = try(var.cloud.portal, {})
    resourceManager                             = try(var.cloud.resourceManager, {})
    sqlManagement                               = try(var.cloud.sqlManagement, {})
    synapseAnalyticsResourceId                  = try(var.cloud.synapseAnalyticsResourceId, {})
    vmImageAliasDoc                             = try(var.cloud.vmImageAliasDoc, {})
  }, var.cloud)


  #------------------------------------------------------------------
  # Azure Resources
  #------------------------------------------------------------------
  analysis_services = try(var.analysis_services, {})

  apim = {
    api_management              = try(var.apim.api_management, {})
    api_management_group        = try(var.apim.api_management_group, {})
    api_management_product      = try(var.apim.api_management_product, {})
    api_management_subscription = try(var.apim.api_management_subscription, {})
  }

  compute = {
    virtual_machines = try(var.compute.virtual_machines, {})
  }

  database = {
    app_config               = try(var.database.app_config, {})
    mssql_databases          = try(var.database.mssql_databases, {})
    mssql_elastic_pools      = try(var.database.mssql_elastic_pools, {})
    mssql_failover_groups    = try(var.database.mssql_failover_groups, {})
    mssql_managed_databases  = try(var.database.mssql_managed_databases, {})
    mssql_managed_instances  = try(var.database.mssql_managed_instances, {})
    mssql_servers            = try(var.database.mssql_servers, {})
    mysql_flexible_databases = try(var.database.mysql_databases, {})
    mysql_flexible_servers   = try(var.database.mysql_servers, {})
    redis_caches             = try(var.database.redis_caches, {})
  }

  data_factory = {
    data_factory                                 = try(var.data_factory.data_factory, {})
    data_factory_pipeline                        = try(var.data_factory.data_factory_pipeline, {})
    data_factory_trigger_schedule                = try(var.data_factory.data_factory_trigger_schedule, {})
    data_factory_integration_runtime_azure_ssis  = try(var.data_factory.data_factory_integration_runtime_azure_ssis, {})
    data_factory_integration_runtime_self_hosted = try(var.data_factory.data_factory_integration_runtime_self_hosted, {})
    datasets = {
      azure_blob       = try(var.data_factory.datasets.azure_blob, {})
      cosmosdb_sqlapi  = try(var.data_factory.datasets.cosmosdb_sqlapi, {})
      delimited_text   = try(var.data_factory.datasets.delimited_text, {})
      http             = try(var.data_factory.datasets.http, {})
      json             = try(var.data_factory.datasets.json, {})
      mysql            = try(var.data_factory.datasets.mysql, {})
      postgresql       = try(var.data_factory.datasets.postgresql, {})
      sql_server_table = try(var.data_factory.datasets.sql_server_table, {})
    }
    linked_services = {
      azure_blob_storage = try(var.data_factory.linked_services.azure_blob_storage, {})
      azure_databricks   = try(var.data_factory.linked_services.azure_databricks, {})
      cosmosdb           = try(var.data_factory.linked_services.cosmosdb, {})
      key_vault          = try(var.data_factory.linked_services.key_vault, {})
      mysql              = try(var.data_factory.linked_services.mysql, {})
      postgresql         = try(var.data_factory.linked_services.postgresql, {})
      sql_server         = try(var.data_factory.linked_services.sql_server, {})
      web                = try(var.data_factory.linked_services.web, {})
    }
  }

  messaging = {
    event_hub_auth_rules           = try(var.messaging.event_hub_auth_rules, {})
    event_hub_consumer_groups      = try(var.messaging.event_hub_consumer_groups, {})
    event_hub_namespace_auth_rules = try(var.messaging.event_hub_namespace_auth_rules, {})
    event_hub_namespaces           = try(var.messaging.event_hub_namespaces, {})
    event_hubs                     = try(var.messaging.event_hubs, {})
  }

  networking = {
    application_gateways                 = try(var.networking.application_gateways, {})
    cdn_frontdoors                       = try(var.networking.cdn_frontdoors, {})
    dns_zones                            = try(var.networking.dns_zones, {})
    express_route_circuits               = try(var.networking.express_route_circuits, {})
    frontdoors                           = try(var.networking.frontdoors, {})
    frontdoor_custom_https_configuration = try(var.networking.frontdoor_custom_https_configuration, {})
    frontdoor_rules_engine               = try(var.networking.frontdoor_rules_engine, {})
    frontdoor_waf_policies               = try(var.networking.frontdoor_waf_policies, {})
    ip_groups                            = try(var.networking.ip_groups, {})
    private_dns                          = try(var.networking.private_dns, {})
    private_dns_resolvers                = try(var.networking.private_dns_resolvers, {})
    private_dns_vnet_links               = try(var.networking.private_dns_vnet_links, {})
    virtual_hubs                         = try(var.networking.virtual_hubs, {})
    virtual_networks                     = try(var.networking.virtual_networks, {})
    virtual_subnets                      = try(var.networking.virtual_subnets, {})
    virtual_wans                         = try(var.networking.virtual_wans, {})
    vpn_sites                            = try(var.networking.vpn_sites, {})
  }

  remote_objects = {
    private_dns_zones = try(var.remote_objects.private_dns, {})
  }

  resource_groups = try(var.resource_groups, {})

  security = {
    dynamic_keyvault_secrets              = try(var.security.dynamic_keyvault_secrets, {})
    keyvaults                             = try(var.security.keyvaults, {})
    keyvault_access_policies              = try(var.security.keyvault_access_policies, {})
    keyvault_access_policies_azuread_apps = try(var.security.keyvault_access_policies_azuread_apps, {})
    managed_identities                    = try(var.security.managed_identities, {})
  }

  shared_services = {
    log_analytics                  = try(var.shared_services.log_analytics, {})
    log_analytics_storage_insights = try(var.shared_services.log_analytics_storage_insights, {})
    monitor_autoscale_settings     = try(var.shared_services.monitor_autoscale_settings, {})
    monitor_action_groups          = try(var.shared_services.monitor_action_groups, {})
    monitoring                     = try(var.shared_services.monitoring, {})
    monitor_metric_alert           = try(var.shared_services.monitor_metric_alert, {})
    monitor_activity_log_alert     = try(var.shared_services.monitor_activity_log_alert, {})
    recovery_vaults                = try(var.shared_services.recovery_vaults, {})
  }

  storage = {
    storage_accounts = try(var.storage.storage_accounts, {})
    storage_syncs    = try(var.storage.storage_syncs, {})
  }

  web = {
    app_insights               = try(var.web.app_insights, {})
    app_service_plans          = try(var.web.app_service_plans, {})
    app_services_linux         = try(var.web.app_services_linux, {})
    app_services_windows       = try(var.web.app_services_windows, {})
    container_app_environments = try(var.web.container_app_environments, {})
    container_apps             = try(var.web.container_apps, {})
    function_apps_linux        = try(var.web.function_apps_linux, {})
    function_apps_windows      = try(var.web.function_apps_windows, {})
    static_sites               = try(var.web.static_sites, {})
  }
}