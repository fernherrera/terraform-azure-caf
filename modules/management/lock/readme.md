<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | (Required) Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly. | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Management Lock. | `any` | n/a | yes |
| <a name="input_notes"></a> [notes](#input\_notes) | (Optional) Specifies some notes about the lock. Maximum of 512 characters. | `any` | `null` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) Specifies the scope at which the Management Lock should be created. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Management Lock |
<!-- END_TF_DOCS -->