#---------------------------------
# Local declarations
#---------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#----------------------------------------------------------
# Container App 
#----------------------------------------------------------
resource "azurerm_container_app" "ca" {
  name                = var.name
  resource_group_name = local.resource_group_name
  tags                = local.tags

  container_app_environment_id = var.container_app_environment_id
  revision_mode                = var.revision_mode

  template {
    dynamic "container" {
      for_each = try(var.template.containers, {})

      content {
        name    = container.name
        image   = container.image
        cpu     = container.cpu
        memory  = container.memory
        args    = try(container.args, null)
        command = try(container.command, null)

        dynamic "env" {
          for_each = try(container.env, {})

          content {
            name        = env.name
            secret_name = try(env.secret_name, null)
            value       = try(env.value, null)
          }
        }

        dynamic "liveness_probe" {
          for_each = try(container.liveness_probe, {})

          content {
            port                    = liveness_probe.port
            transport               = liveness_probe.transport
            failure_count_threshold = try(liveness_probe.failure_count_threshold, null)
            host                    = try(liveness_probe.host, null)
            initial_delay           = try(liveness_probe.initial_delay, 1)
            interval_seconds        = try(liveness_probe.interval_seconds, 10)
            path                    = try(liveness_probe.path, null)
            timeout                 = try(liveness_probe.timeout, 1)

            dynamic "header" {
              for_each = try(liveness_probe.header, null) != null ? [1] : []

              content {
                name  = header.name
                value = header.value
              }
            }
          }
        }

        dynamic "readiness_probe" {
          for_each = try(container.readiness_probe, {})

          content {
            port                    = readiness_probe.port
            transport               = readiness_probe.transport
            failure_count_threshold = try(readiness_probe.failure_count_threshold, null)
            host                    = try(readiness_probe.host, null)
            success_count_threshold = try(readiness_probe.success_count_threshold, 3)
            interval_seconds        = try(readiness_probe.interval_seconds, 10)
            path                    = try(readiness_probe.path, null)
            timeout                 = try(readiness_probe.timeout, 1)

            dynamic "header" {
              for_each = try(readiness_probe.header, null) != null ? [1] : []

              content {
                name  = header.name
                value = header.value
              }
            }
          }
        }

        dynamic "startup_probe" {
          for_each = try(container.startup_probe, {})

          content {
            port                    = startup_probe.port
            transport               = startup_probe.transport
            failure_count_threshold = try(startup_probe.failure_count_threshold, null)
            host                    = try(startup_probe.host, null)
            interval_seconds        = try(startup_probe.interval_seconds, 10)
            path                    = try(startup_probe.path, null)
            timeout                 = try(startup_probe.timeout, 1)

            dynamic "header" {
              for_each = try(startup_probe.header, null) != null ? [1] : []

              content {
                name  = header.name
                value = header.value
              }
            }
          }
        }

        dynamic "volume_mounts" {
          for_each = try(container.volume_mounts, {})

          content {
            name = volume_mounts.name
            path = volume_mounts.path
          }
        }

      }
    }

    max_replicas    = try(var.template.max_replicas, null)
    min_replicas    = try(var.template.min_replicas, null)
    revision_suffix = try(var.template.revision_suffix, null)

    dynamic "volume" {
      for_each = try(var.template.volume, {})

      content {
        name         = volume.name
        storage_name = try(volume.storage_name, null)
        storage_type = try(volume.storage_type, null)
      }
    }
  }

  dynamic "dapr" {
    for_each = try(var.dapr, null) != null ? [1] : []

    content {
      app_id       = var.dapr.app_id
      app_port     = var.dapr.app_port
      app_protocol = try(var.dapr.app_protocol, null)
    }
  }

  dynamic "identity" {
    for_each = length(local.managed_identities) > 0 || local.identity_type == "UserAssigned" ? [local.identity_type] : []

    content {
      type         = local.identity_type
      identity_ids = lower(local.identity_type) == "userassigned" ? local.managed_identities : null
    }
  }

  dynamic "ingress" {
    for_each = try(var.ingress, null) != null ? [1] : []

    content {
      allow_insecure_connections = try(var.ingress.allow_insecure_connections, false)
      external_enabled           = try(var.ingress.external_enabled, false)
      target_port                = var.ingress.target_port
      transport                  = try(var.ingress.transport, null)

      traffic_weight {
        label           = try(var.ingress.traffic_weight.label, null)
        latest_revision = try(var.ingress.traffic_weight.latest_revision, null)
        revision_suffix = try(var.ingress.traffic_weight.revision_suffix, null)
        percentage      = var.ingress.traffic_weight.percentage
      }
    }
  }

  dynamic "registry" {
    for_each = try(var.registry, null) != null ? [1] : []

    content {
      server               = var.registry.server
      username             = try(var.registry.username, null)
      password_secret_name = try(var.registry.password_secret_name, null)
      identity             = try(var.registry.identity, null)
    }
  }

  dynamic "secret" {
    for_each = try(var.secret, {})

    content {
      name  = secret.name
      value = secret.value
    }
  }

}