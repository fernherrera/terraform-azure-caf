<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| redis\_cache | ./redis_cache | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_group.group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_group) | resource |
| [azurerm_api_management_named_value.named_values](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_product.product](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_group.product_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_group) | resource |
| [azurerm_api_management_redis_cache.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_redis_cache) | resource |
| [azurerm_api_management.apim_e](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_location | (Optional) List of the name of the Azure Region in which the API Management Service should be expanded to. | `list(map(string))` | `[]` | no |
| certificate\_configuration | (Optional) List of certificate configurations | `list(map(string))` | `[]` | no |
| client\_certificate\_enabled | (Optional) Enforce a client certificate to be presented on each request to the gateway? This is only supported when SKU type is `Consumption`. | `bool` | `false` | no |
| create\_product\_group\_and\_relationships | (Optional) Create local APIM groups with name identical to products and create a relationship between groups and products | `bool` | `false` | no |
| developer\_portal\_hostname\_configuration | (Optional) Developer portal hostname configurations | `list(map(string))` | `[]` | no |
| enable\_http2 | (Optional) Should HTTP/2 be supported by the API Management Service? | `bool` | `false` | no |
| enable\_sign\_in | (Optional) Should anonymous users be redirected to the sign in page? | `bool` | `false` | no |
| enable\_sign\_up | (Optional) Can users sign up on the development portal? | `bool` | `false` | no |
| existing | (Optional) Whether to reference an existing resource group. | `bool` | `false` | no |
| gateway\_disabled | (Optional) Disable the gateway in main region? This is only supported when `additional_location` is set. | `bool` | `false` | no |
| identity | (Optional) An identity block. | `any` | `null` | no |
| location | (Required) The Azure location where the API Management Service exists. | `string` | n/a | yes |
| management\_hostname\_configuration | (Optional) List of management hostname configurations | `list(map(string))` | `[]` | no |
| min\_api\_version | (Optional) The version which the control plane API calls to API Management service are limited with version equal to or newer than. | `string` | `null` | no |
| name | (Required) The name of the API Management Service. | `string` | n/a | yes |
| named\_values | (Optional) Map containing the name of the named values as key and value as values | `list(map(string))` | `[]` | no |
| notification\_sender\_email | (Optional) Email address from which the notification will be sent | `string` | `null` | no |
| policy\_configuration | Map of policy configuration | `map(string)` | `{}` | no |
| portal\_hostname\_configuration | (Optional) Legacy portal hostname configurations | `list(map(string))` | `[]` | no |
| products | (Optional) List of products to create | `list(string)` | `[]` | no |
| proxy\_hostname\_configuration | (Optional) List of proxy hostname configurations | `list(map(string))` | `[]` | no |
| publisher\_email | (Required) The email of publisher/company. | `string` | n/a | yes |
| publisher\_name | (Required) The name of publisher/company. | `string` | n/a | yes |
| redis\_cache\_configuration | (Optional) Map of redis cache configurations | `map` | `{}` | no |
| resource\_group\_name | (Required) The name of the Resource Group in which the API Management Service should be exist. | `string` | n/a | yes |
| scm\_hostname\_configuration | (Optional) List of scm hostname configurations | `list(map(string))` | `[]` | no |
| security\_configuration | (Optional) Map of security configuration | `map(string)` | `{}` | no |
| sku\_name | (Required) String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity | `string` | `"Basic_1"` | no |
| subnets | Virtual subnet networks configuration object | `any` | n/a | yes |
| tags | (Optional) A mapping of tags assigned to the resource. | `map(string)` | `{}` | no |
| terms\_of\_service\_configuration | (Optional) Map of terms of service configuration | `list(map(string))` | ```[ { "consent_required": false, "enabled": false, "text": "" } ]``` | no |
| virtual\_network\_configuration | (Optional) The id(s) of the subnet(s) that will be used for the API Management. Required when virtual\_network\_type is External or Internal | `any` | `null` | no |
| virtual\_network\_type | (Optional) The type of virtual network you want to use, valid values include: None, External, Internal. | `string` | `null` | no |
| zones | (Optional) Specifies a list of Availability Zones in which this API Management service should be located. Changing this forces a new API Management service to be created. Supported in Premium Tier. | `list(number)` | ```[ 1, 2, 3 ]``` | no |

## Outputs

| Name | Description |
|------|-------------|
| api\_management\_additional\_location | Map listing gateway\_regional\_url and public\_ip\_addresses associated |
| api\_management\_gateway\_regional\_url | The Region URL for the Gateway of the API Management Service |
| api\_management\_gateway\_url | The URL of the Gateway for the API Management Service |
| api\_management\_id | The ID of the API Management Service |
| api\_management\_identity | The identity of the API Management |
| api\_management\_management\_api\_url | The URL for the Management API associated with this API Management service |
| api\_management\_name | The name of the API Management Service |
| api\_management\_portal\_url | The URL for the Publisher Portal associated with this API Management service |
| api\_management\_private\_ip\_addresses | The Private IP addresses of the API Management Service |
| api\_management\_public\_ip\_addresses | The Public IP addresses of the API Management Service |
| api\_management\_scm\_url | The URL for the SCM Endpoint associated with this API Management service |
<!-- END_TF_DOCS -->