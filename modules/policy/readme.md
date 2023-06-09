# Azure Policy Module

Terraform module to create policies and apply them to different scopes. It can either create a new policy and assign, or use an existing policy definition.

If applying policies to management groups the id should be set to `/providers/Microsoft.Management/managementGroups/group_id`.

Assignments id is mapped to azurerm provider resources as follows:

| id                                                                             | azurerm resource                           |
|--------------------------------------------------------------------------------|--------------------------------------------|
| /providers/Microsoft.Management/managementGroups/...                           | azurerm_management_group_policy_assignment |
| /subscriptions/00000000-0000-0000-0000-000000000000                            | azurerm_subscription_policy_assignment     |
| /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup     | azurerm_resource_group_policy_assignment   |
| /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup/... | azurerm_resource_policy_assignment         |

Assignments to different resource types is supported.

## Required parameters

Although both `policy_definition_id` and `custom_policy` are optionally at least one of them have to be defined. If custom policy is defined it will overwrite `policy_definition_id`.

## Usage

To use the build-in policy to restrict resource locations to specific regions:

```terraform
module "restrict-location" {
    source = "terraform-modules/azurerm/policy/"

    name        = "restrict-location"
    description = "Restrict location that its allowed to create resources in."
    location    = "westeurope"

    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

    assignments = [
        {
            display_name = "Restrict resource location"
            id           = "/providers/Microsoft.Management/managementGroups/group_id"
            not_scopes   = []
            parameters   = <<PARAMETERS
                {
                    "listOfAllowedLocations": {
                        "value": [ "West Europe" ]
                    }
                }
            PARAMETERS
            exemption    = {
               name                            = "exemption-1"
               display_name                    = "Exemptio One"
               exemption_category              = "Waiver"
               policy_definition_reference_ids = ["identityEnableMFAForWritePermissionsMonitoring"]
          }
        },
    ]
}
```

If the build-in policies do not cover use case it is also possible to add a custom policy:

```terraform
module "restrict-location" {
    source = "terraform-modules/azurerm/policy/"

    name = "restrict-location"
    description = "Restrict location that its allowed to create resources in."
    location = "westeurope"

    custom_policy = {
        display_name        = "Restrict location"
        mode                = "All"
        management_group_id = ""

        metadata = <<METADATA
            {
                "category": "General"
            }
        METADATA

        policy_rule = <<POLICY_RULE
            {
                "if": {
                    "not": {
                        "field": "location",
                        "in": "[parameters('allowedLocations')]"
                    }
                },
                "then": {
                    "effect": "audit"
                }
            }
        POLICY_RULE

        parameters = <<PARAMETERS
            {
                "allowedLocations": {
                    "type": "Array",
                    "metadata": {
                        "description": "The list of allowed locations for resources.",
                        "displayName": "Allowed locations",
                        "strongType": "location"
                    }
                }
            }
        PARAMETERS
        exemption = null
    }

    assignments = [
        {
            display_name = "Restrict resource location"
            id           = "/providers/Microsoft.Management/managementGroups/group_id"
            not_scopes   = []
            parameters   = <<PARAMETERS
                {
                    "allowedLocations": {
                        "value": [ "West Europe" ]
                    }
                }
            PARAMETERS
            exemption = null
        },
    ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_assignment.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_exemption.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_exemption) | resource |
| [azurerm_policy_definition.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |
| [azurerm_resource_group_policy_assignment.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_assignment) | resource |
| [azurerm_resource_group_policy_exemption.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_exemption) | resource |
| [azurerm_resource_policy_assignment.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_assignment) | resource |
| [azurerm_resource_policy_exemption.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_exemption) | resource |
| [azurerm_subscription_policy_assignment.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_subscription_policy_exemption.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_exemption) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignments"></a> [assignments](#input\_assignments) | A list of policies to assign to resource id | <pre>list(object({<br>    display_name = string<br>    id           = string<br>    not_scopes   = list(string)<br>    parameters   = string<br>    exemption = object({<br>      name                            = string<br>      display_name                    = string<br>      exemption_category              = string<br>      policy_definition_reference_ids = list(string)<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_create_identity"></a> [create\_identity](#input\_create\_identity) | Set to true to create a system assigned managed identity. Required for policies that use deploy effect. | `bool` | `false` | no |
| <a name="input_custom_policy"></a> [custom\_policy](#input\_custom\_policy) | A custom policy to create, will overwrite policy\_definition\_id. Both cannot be configured at same time. | <pre>object({<br>    display_name        = string<br>    mode                = string<br>    management_group_id = string<br>    metadata            = string<br>    policy_rule         = string<br>    parameters          = string<br>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what this policy does. Added to both definition and assignment. | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region in which to create resource. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Short name of this policy assignment. | `any` | n/a | yes |
| <a name="input_policy_definition_id"></a> [policy\_definition\_id](#input\_policy\_definition\_id) | The ID of the Policy Definition to be applied at the scope. If `custom_policy` variable is defined it will ignore this. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_definition_id"></a> [policy\_definition\_id](#output\_policy\_definition\_id) | Azure policy ID |
<!-- END_TF_DOCS -->