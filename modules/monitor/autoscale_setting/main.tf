#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

#----------------------------------------------------------
# Monitor Autoscale Setting Creation 
#----------------------------------------------------------
resource "azurerm_monitor_autoscale_setting" "mas" {
  name                = var.name
  resource_group_name = local.resource_group_name
  location            = local.location
  tags                = local.tags

  target_resource_id = var.target_resource_id
  enabled            = var.enabled

  dynamic "profile" {
    for_each = var.profiles

    content {
      name = profile.value.name

      capacity {
        default = profile.value.capacity.default
        minimum = profile.value.capacity.minimum
        maximum = profile.value.capacity.maximum
      }

      dynamic "rule" {
        for_each = try(profile.value.rules, {})

        content {
          metric_trigger {
            metric_name              = rule.value.metric_trigger.metric_name
            metric_resource_id       = try(rule.value.metric_trigger.metric_resource_id, var.target_resource_id)
            time_grain               = rule.value.metric_trigger.time_grain
            statistic                = rule.value.metric_trigger.statistic
            time_window              = rule.value.metric_trigger.time_window
            time_aggregation         = rule.value.metric_trigger.time_aggregation
            operator                 = rule.value.metric_trigger.operator
            threshold                = rule.value.metric_trigger.threshold
            metric_namespace         = try(rule.value.metric_trigger.metric_namespace, null)
            divide_by_instance_count = try(rule.value.metric_trigger.divide_by_instance_count, null)

            dynamic "dimensions" {
              for_each = try(rule.value.metric_trigger.dimensions, {})

              content {
                name     = dimensions.value.name
                operator = dimensions.value.operator
                values   = dimensions.value.values
              }
            }
          }
          scale_action {
            direction = rule.value.scale_action.direction
            type      = rule.value.scale_action.type
            value     = rule.value.scale_action.value
            cooldown  = rule.value.scale_action.cooldown
          }
        }
      }

      dynamic "recurrence" {
        for_each = try(var.profiles[profile.key].recurrence, {}) == {} ? [] : [1]

        content {
          timezone = var.profiles[profile.key].recurrence.timezone
          days     = var.profiles[profile.key].recurrence.days
          hours    = var.profiles[profile.key].recurrence.hours
          minutes  = var.profiles[profile.key].recurrence.minutes
        }
      }

      dynamic "fixed_date" {
        for_each = try(var.profiles[profile.key].fixed_date, {}) == {} ? [] : [1]

        content {
          timezone = try(var.profiles[profile.key].fixed_date.timezone, null)
          start    = var.profiles[profile.key].fixed_date.start
          end      = var.profiles[profile.key].fixed_date.end
        }
      }

    }
  }

  dynamic "notification" {
    for_each = try(var.notification, {}) == {} ? [] : [1]

    content {
      dynamic "email" {
        for_each = try(var.notification.email, {}) == {} ? [] : [1]

        content {
          send_to_subscription_administrator    = try(var.notification.email.send_to_subscription_administrator, null)
          send_to_subscription_co_administrator = try(var.notification.email.send_to_subscription_co_administrator, null)
          custom_emails                         = try(var.notification.email.custom_emails, null)
        }
      }

      dynamic "webhook" {
        for_each = try(var.profiles.notification.webhook, {}) == {} ? [] : [1]

        content {
          service_uri = var.profiles.notification.webhook.service.uri
          properties  = try(var.profiles.notification.webhook.properties, null)
        }
      }
    }
  }
}