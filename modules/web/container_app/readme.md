<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app.ca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_app\_environment\_id | (Required) The ID of the Container App Environment within which this Container App should exist. Changing this forces a new resource to be created. | `any` | n/a | yes |
| dapr | (Optional) A dapr block. | `map` | `{}` | no |
| identity | (Optional) An identity block. | `any` | `null` | no |
| ingress | (Optional) An ingress block. | `map` | `{}` | no |
| name | (Required) The name for this Container App. Changing this forces a new resource to be created. | `any` | n/a | yes |
| registry | (Optional) A registry block. | `map` | `{}` | no |
| resource\_group\_name | Required) The name of the resource group in which the Container App Environment is to be created. Changing this forces a new resource to be created. | `any` | n/a | yes |
| revision\_mode | (Required) The revisions operational mode for the Container App. Possible values include Single and Multiple. In Single mode, a single revision is in operation at any given time. In Multiple mode, more than one revision can be active at a time and can be configured with load distribution via the traffic\_weight block in the ingress configuration. | `any` | n/a | yes |
| secret | (Optional) One or more secret block. | `map` | `{}` | no |
| tags | (Optional) A mapping of tags to assign to the Container App. | `map` | `{}` | no |
| template | (Required) A template block. | ```object({ containers = set(object({ name = string image = string args = optional(list(string)) command = optional(list(string)) cpu = string memory = string env = optional(set(object({ name = string secret_name = optional(string) value = string }))) liveness_probe = optional(object({ failure_count_threshold = optional(number) header = optional(object({ name = string value = string })) host = optional(string) initial_delay = optional(number, 1) interval_seconds = optional(number, 10) path = optional(string) port = number timeout = optional(number, 1) transport = string })) readiness_probe = optional(object({ failure_count_threshold = optional(number) header = optional(object({ name = string value = string })) host = optional(string) interval_seconds = optional(number, 10) path = optional(string) port = number success_count_threshold = optional(number, 3) timeout = optional(number) transport = string })) startup_probe = optional(object({ failure_count_threshold = optional(number) header = optional(object({ name = string value = string })) host = optional(string) interval_seconds = optional(number, 10) path = optional(string) port = number timeout = optional(number) transport = string })) volume_mounts = optional(object({ name = string path = string })) })) max_replicas = optional(number) min_replicas = optional(number) revision_suffix = optional(string) volume = optional(list(object({ name = string storage_name = optional(string) storage_type = optional(string) }))) })``` | n/a | yes |
<!-- END_TF_DOCS -->