variable "name" {
  description = "(Required) The name for this Container App. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "Required) The name of the resource group in which the Container App Environment is to be created. Changing this forces a new resource to be created."
}

variable "container_app_environment_id" {
  description = "(Required) The ID of the Container App Environment within which this Container App should exist. Changing this forces a new resource to be created."
}

variable "revision_mode" {
  description = "(Required) The revisions operational mode for the Container App. Possible values include Single and Multiple. In Single mode, a single revision is in operation at any given time. In Multiple mode, more than one revision can be active at a time and can be configured with load distribution via the traffic_weight block in the ingress configuration."
}

variable "template" {
  description = "(Required) A template block."
  type = object({
    containers = set(object({
      name    = string
      image   = string
      args    = optional(list(string))
      command = optional(list(string))
      cpu     = string
      memory  = string
      env = optional(set(object({
        name        = string
        secret_name = optional(string)
        value       = string
      })))
      liveness_probe = optional(object({
        failure_count_threshold = optional(number)
        header = optional(object({
          name  = string
          value = string
        }))
        host             = optional(string)
        initial_delay    = optional(number, 1)
        interval_seconds = optional(number, 10)
        path             = optional(string)
        port             = number
        timeout          = optional(number, 1)
        transport        = string
      }))
      readiness_probe = optional(object({
        failure_count_threshold = optional(number)
        header = optional(object({
          name  = string
          value = string
        }))
        host                    = optional(string)
        interval_seconds        = optional(number, 10)
        path                    = optional(string)
        port                    = number
        success_count_threshold = optional(number, 3)
        timeout                 = optional(number)
        transport               = string
      }))
      startup_probe = optional(object({
        failure_count_threshold = optional(number)
        header = optional(object({
          name  = string
          value = string
        }))
        host             = optional(string)
        interval_seconds = optional(number, 10)
        path             = optional(string)
        port             = number
        timeout          = optional(number)
        transport        = string
      }))
      volume_mounts = optional(object({
        name = string
        path = string
      }))
    }))
    max_replicas    = optional(number)
    min_replicas    = optional(number)
    revision_suffix = optional(string)

    volume = optional(list(object({
      name         = string
      storage_name = optional(string)
      storage_type = optional(string)
    })))
  })
}

variable "dapr" {
  description = "(Optional) A dapr block."
  default     = {}
  type = object({
    app_id       = string
    app_port     = number
    app_protocol = optional(string)
  })
}

variable "identity" {
  description = "(Optional) An identity block."
  default     = {}
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
}

variable "ingress" {
  description = "(Optional) An ingress block."
  default     = {}
  type = object({
    allow_insecure_connections = optional(bool, false)
    external_enabled           = optional(bool, false)
    target_port                = number
    transport                  = optional(string)
    traffic_weight = object({
      label           = optional(string)
      latest_revision = optional(string)
      revision_suffix = optional(string)
      percentage      = number
    })
  })
}

variable "registry" {
  description = "(Optional) A registry block."
  default     = {}
  type = list(object({
    server               = string
    username             = optional(string)
    password_secret_name = optional(string)
    identity             = optional(string)
  }))
}

variable "secret" {
  description = "(Optional) One or more secret block."
  default     = {}
  type = list(object({
    name  = string
    value = string
  }))
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the Container App."
  default     = {}
}