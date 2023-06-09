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
| [azurerm_express_route_circuit.circuit](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_classic_operations"></a> [allow\_classic\_operations](#input\_allow\_classic\_operations) | (Optional) Allow the circuit to interact with classic (RDFE) resources. Defaults to false. | `bool` | `false` | no |
| <a name="input_bandwidth_in_gbps"></a> [bandwidth\_in\_gbps](#input\_bandwidth\_in\_gbps) | (Optional) The bandwidth in Gbps of the circuit being created on the Express Route Port. | `any` | `null` | no |
| <a name="input_bandwidth_in_mbps"></a> [bandwidth\_in\_mbps](#input\_bandwidth\_in\_mbps) | (Optional) The bandwidth in Mbps of the circuit being created on the Service Provider. | `any` | `null` | no |
| <a name="input_express_route_port_id"></a> [express\_route\_port\_id](#input\_express\_route\_port\_id) | (Optional) The ID of the Express Route Port this Express Route Circuit is based on. | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the ExpressRoute circuit. | `any` | n/a | yes |
| <a name="input_peering_location"></a> [peering\_location](#input\_peering\_location) | (Optional) The name of the peering location and not the Azure resource location. | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the ExpressRoute circuit. | `string` | n/a | yes |
| <a name="input_service_provider_name"></a> [service\_provider\_name](#input\_service\_provider\_name) | (Optional) The name of the ExpressRoute Service Provider. | `any` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) A sku block for the ExpressRoute circuit | <pre>map(object({<br>    tier   = string<br>    family = string<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Express Route Circuit ID |
| <a name="output_service_key"></a> [service\_key](#output\_service\_key) | The string needed by the service provider to provision the ExpressRoute circuit. |
| <a name="output_service_provider_provisioning_state"></a> [service\_provider\_provisioning\_state](#output\_service\_provider\_provisioning\_state) | The ExpressRoute circuit provisioning state from your chosen service provider. |
<!-- END_TF_DOCS -->